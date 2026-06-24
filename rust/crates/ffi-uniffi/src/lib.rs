use std::sync::Arc;

use core_domain::models;

uniffi::setup_scaffolding!();

// ── Error ─────────────────────────────────────────────────────────────────────

#[derive(Debug, thiserror::Error, uniffi::Error)]
pub enum CoreError {
    #[error("database error: {msg}")]
    Database { msg: String },
    #[error("network error: {msg}")]
    Network { msg: String },
    #[error("parse error: {msg}")]
    Parse { msg: String },
    #[error("{msg}")]
    Other { msg: String },
}

// ── FFI Records ───────────────────────────────────────────────────────────────

#[derive(uniffi::Record)]
pub struct FfiProvider {
    pub id: String,
    pub name: String,
    pub provider_type: String,
    pub url: String,
    pub username: Option<String>,
    pub password: Option<String>,
    pub epg_url: Option<String>,
    pub last_sync: i64,
    pub is_active: bool,
}

#[derive(uniffi::Record)]
pub struct FfiChannel {
    pub id: String,
    pub provider_id: String,
    pub name: String,
    pub stream_url: String,
    pub logo_url: Option<String>,
    pub group: String,
    pub country: Option<String>,
    pub tvg_id: Option<String>,
    pub catchup_support: bool,
}

#[derive(uniffi::Record)]
pub struct FfiEpgEntry {
    pub channel_id: String,
    pub title: String,
    pub description: Option<String>,
    pub start: i64,
    pub end: i64,
    pub category: Option<String>,
    pub poster_url: Option<String>,
}

#[derive(uniffi::Record)]
pub struct FfiPlaylist {
    pub id: String,
    pub name: String,
    pub channel_ids: Vec<String>,
    pub created_at: i64,
    pub is_favorites: bool,
}

#[derive(uniffi::Record)]
pub struct FfiWatchHistory {
    pub channel_id: String,
    pub started_at: i64,
    pub duration_seconds: u64,
}

// ── Conversions ───────────────────────────────────────────────────────────────

impl From<models::Provider> for FfiProvider {
    fn from(p: models::Provider) -> Self {
        FfiProvider {
            id: p.id,
            name: p.name,
            provider_type: p.provider_type.to_string(),
            url: p.url,
            username: p.credentials.as_ref().map(|c| c.username.clone()),
            password: p.credentials.as_ref().map(|c| c.password.clone()),
            epg_url: p.epg_url,
            last_sync: p.last_sync,
            is_active: p.is_active,
        }
    }
}

impl From<models::Channel> for FfiChannel {
    fn from(c: models::Channel) -> Self {
        FfiChannel {
            id: c.id,
            provider_id: c.provider_id,
            name: c.name,
            stream_url: c.stream_url,
            logo_url: c.logo_url,
            group: c.group,
            country: c.country,
            tvg_id: c.tvg_id,
            catchup_support: c.catchup_support,
        }
    }
}

impl From<models::EpgEntry> for FfiEpgEntry {
    fn from(e: models::EpgEntry) -> Self {
        FfiEpgEntry {
            channel_id: e.channel_id,
            title: e.title,
            description: e.description,
            start: e.start,
            end: e.end,
            category: e.category,
            poster_url: e.poster_url,
        }
    }
}

impl From<models::Playlist> for FfiPlaylist {
    fn from(p: models::Playlist) -> Self {
        FfiPlaylist {
            id: p.id,
            name: p.name,
            channel_ids: p.channel_ids,
            created_at: p.created_at,
            is_favorites: p.is_favorites,
        }
    }
}

fn ffi_to_provider(ffi: FfiProvider) -> models::Provider {
    models::Provider {
        id: ffi.id,
        name: ffi.name,
        provider_type: match ffi.provider_type.as_str() {
            "xtream_codes" => models::ProviderType::XtreamCodes,
            "mag" => models::ProviderType::Mag,
            _ => models::ProviderType::M3u,
        },
        url: ffi.url,
        credentials: match (ffi.username, ffi.password) {
            (Some(u), Some(p)) => Some(models::Credentials {
                username: u,
                password: p,
            }),
            _ => None,
        },
        epg_url: ffi.epg_url,
        last_sync: ffi.last_sync,
        is_active: ffi.is_active,
    }
}

fn ffi_to_playlist(ffi: FfiPlaylist) -> models::Playlist {
    models::Playlist {
        id: ffi.id,
        name: ffi.name,
        channel_ids: ffi.channel_ids,
        created_at: ffi.created_at,
        is_favorites: ffi.is_favorites,
    }
}

// ── Core Object ───────────────────────────────────────────────────────────────

#[derive(uniffi::Object)]
pub struct MiPTVCore {
    db: core_data::db::Database,
    http: core_data::http::HttpClient,
}

#[uniffi::export(async_runtime = "tokio")]
impl MiPTVCore {
    #[uniffi::constructor]
    pub async fn init(db_path: String) -> Result<Arc<Self>, CoreError> {
        let db = core_data::db::Database::open(&db_path)
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;
        let http = core_data::http::HttpClient::new().map_err(|e| CoreError::Network { msg: e.to_string() })?;
        Ok(Arc::new(Self { db, http }))
    }

    pub async fn add_provider(&self, provider: FfiProvider) -> Result<(), CoreError> {
        self.db
            .insert_provider(&ffi_to_provider(provider))
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })
    }

    pub async fn list_providers(&self) -> Result<Vec<FfiProvider>, CoreError> {
        let providers = self
            .db
            .list_providers()
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;
        Ok(providers.into_iter().map(FfiProvider::from).collect())
    }

    pub async fn delete_provider(&self, id: String) -> Result<(), CoreError> {
        self.db
            .delete_provider(&id)
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })
    }

    pub async fn sync_provider(&self, provider_id: String) -> Result<u64, CoreError> {
        let providers = self
            .db
            .list_providers()
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;
        let provider = providers
            .into_iter()
            .find(|p| p.id == provider_id)
            .ok_or_else(|| CoreError::Other {
                msg: format!("provider {provider_id} not found"),
            })?;
        let sync = core_data::sync::ProviderSync::new(self.http.clone(), self.db.clone());
        let count = sync
            .sync(&provider)
            .await
            .map_err(|e| CoreError::Network { msg: e.to_string() })?;
        Ok(count as u64)
    }

    pub async fn list_channels(&self, provider_id: String) -> Result<Vec<FfiChannel>, CoreError> {
        let channels = self
            .db
            .list_channels(Some(&provider_id))
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;
        Ok(channels.into_iter().map(FfiChannel::from).collect())
    }

    pub async fn search_channels(&self, query: String) -> Result<Vec<FfiChannel>, CoreError> {
        let channels = self
            .db
            .search_channels(&query)
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;
        Ok(channels.into_iter().map(FfiChannel::from).collect())
    }

    pub async fn sync_epg(&self, provider_id: String) -> Result<u64, CoreError> {
        let providers = self
            .db
            .list_providers()
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;
        let provider = providers
            .into_iter()
            .find(|p| p.id == provider_id)
            .ok_or_else(|| CoreError::Other {
                msg: format!("provider {provider_id} not found"),
            })?;
        let epg_url = provider.epg_url.ok_or_else(|| CoreError::Other {
            msg: format!("provider {provider_id} has no EPG URL configured"),
        })?;

        let xml = self
            .http
            .fetch_text(&epg_url)
            .await
            .map_err(|e| CoreError::Network { msg: e.to_string() })?;

        let entries = parser_xmltv::parse(&xml).map_err(|e| CoreError::Parse { msg: e.to_string() })?;
        let count = entries.len() as u64;

        // Replace stale EPG data for this provider
        self.db
            .delete_epg_for_provider(&provider_id)
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;

        // Purge entries from any provider that ended >24 h ago
        let now = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .unwrap_or_default()
            .as_secs() as i64;
        self.db
            .purge_old_epg_entries(now - 86_400)
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;

        self.db
            .upsert_epg_entries(&entries)
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;

        Ok(count)
    }

    pub async fn get_current_epg(&self, channel_id: String) -> Result<Option<FfiEpgEntry>, CoreError> {
        let now = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .unwrap_or_default()
            .as_secs() as i64;
        let entry = self
            .db
            .get_current_epg(&channel_id, now)
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;
        Ok(entry.map(FfiEpgEntry::from))
    }

    pub async fn get_epg_for_channel(
        &self,
        channel_id: String,
        start: i64,
        end: i64,
    ) -> Result<Vec<FfiEpgEntry>, CoreError> {
        let entries = self
            .db
            .get_epg_for_channel(&channel_id, start, end)
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;
        Ok(entries.into_iter().map(FfiEpgEntry::from).collect())
    }

    pub async fn create_playlist(&self, playlist: FfiPlaylist) -> Result<(), CoreError> {
        self.db
            .insert_playlist(&ffi_to_playlist(playlist))
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })
    }

    pub async fn list_playlists(&self) -> Result<Vec<FfiPlaylist>, CoreError> {
        let playlists = self
            .db
            .list_playlists()
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;
        Ok(playlists.into_iter().map(FfiPlaylist::from).collect())
    }

    pub async fn update_playlist(&self, playlist: FfiPlaylist) -> Result<(), CoreError> {
        self.db
            .update_playlist(&ffi_to_playlist(playlist))
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })
    }

    pub async fn delete_playlist(&self, id: String) -> Result<(), CoreError> {
        self.db
            .delete_playlist(&id)
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })
    }

    pub async fn record_watch(
        &self,
        channel_id: String,
        started_at: i64,
        duration_seconds: u64,
    ) -> Result<(), CoreError> {
        let entry = models::WatchHistory {
            channel_id,
            started_at,
            duration_seconds,
        };
        self.db
            .record_watch(&entry)
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })
    }

    pub async fn get_recently_watched(&self, limit: u64) -> Result<Vec<FfiChannel>, CoreError> {
        let channels = self
            .db
            .get_recently_watched_channels(limit as i64)
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;
        Ok(channels.into_iter().map(FfiChannel::from).collect())
    }

    pub async fn get_most_watched(&self, limit: u64) -> Result<Vec<FfiChannel>, CoreError> {
        let channels = self
            .db
            .get_most_watched_channels(limit as i64)
            .await
            .map_err(|e| CoreError::Database { msg: e.to_string() })?;
        Ok(channels.into_iter().map(FfiChannel::from).collect())
    }
}
