use anyhow::Result;
use core_domain::models::{Channel, Provider, ProviderType};
use tracing::info;

use crate::{
    db::Database,
    http::{HttpClient, XtreamClient},
};

/// Orchestrates fetching channels from a provider and persisting them.
pub struct ProviderSync {
    http: HttpClient,
    db: Database,
}

impl ProviderSync {
    pub fn new(http: HttpClient, db: Database) -> Self {
        Self { http, db }
    }

    pub async fn sync(&self, provider: &Provider) -> Result<usize> {
        let channels = match &provider.provider_type {
            ProviderType::M3u => self.sync_m3u(provider).await?,
            ProviderType::XtreamCodes => self.sync_xtream(provider).await?,
            ProviderType::Mag => {
                tracing::warn!("MAG sync not yet implemented");
                vec![]
            }
        };

        let count = channels.len();
        self.db.upsert_channels(&channels).await?;
        info!(provider_id = %provider.id, channels = count, "sync complete");
        Ok(count)
    }

    async fn sync_m3u(&self, provider: &Provider) -> Result<Vec<Channel>> {
        let text = self.http.fetch_text(&provider.url).await?;
        let channels = parser_m3u::parse(&provider.id, &text).map_err(|e| anyhow::anyhow!("M3U parse error: {e}"))?;
        Ok(channels)
    }

    async fn sync_xtream(&self, provider: &Provider) -> Result<Vec<Channel>> {
        let creds = provider
            .credentials
            .as_ref()
            .ok_or_else(|| anyhow::anyhow!("Xtream Codes provider missing credentials"))?;

        let client = XtreamClient::new(self.http.clone(), &provider.url, &creds.username, &creds.password);

        let streams = client.get_live_streams().await?;
        let channels = streams
            .into_iter()
            .map(|s| {
                let stream_url = client.stream_url(s.stream_id);
                Channel {
                    id: format!("{}:{}", provider.id, s.stream_id),
                    provider_id: provider.id.clone(),
                    name: s.name,
                    stream_url,
                    logo_url: if s.stream_icon.is_empty() {
                        None
                    } else {
                        Some(s.stream_icon)
                    },
                    group: s.category_id,
                    country: None,
                    languages: vec![],
                    tvg_id: if s.epg_channel_id.is_empty() {
                        None
                    } else {
                        Some(s.epg_channel_id)
                    },
                    catchup_support: false,
                }
            })
            .collect();

        Ok(channels)
    }
}
