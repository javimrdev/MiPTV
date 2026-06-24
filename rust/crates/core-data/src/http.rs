use anyhow::Result;
use reqwest::Client;
use serde::Deserialize;

/// Thin HTTP wrapper — one client instance per app, cheaply cloneable.
#[derive(Clone)]
pub struct HttpClient {
    inner: Client,
}

impl HttpClient {
    pub fn new() -> Result<Self> {
        let inner = Client::builder()
            .timeout(std::time::Duration::from_secs(30))
            .user_agent("MiPTV/0.1")
            .build()?;
        Ok(Self { inner })
    }

    /// Fetch raw bytes (used for M3U and XMLTV downloads).
    pub async fn fetch_bytes(&self, url: &str) -> Result<Vec<u8>> {
        let response = self.inner.get(url).send().await?.error_for_status()?;
        Ok(response.bytes().await?.to_vec())
    }

    /// Fetch UTF-8 text.
    pub async fn fetch_text(&self, url: &str) -> Result<String> {
        let bytes = self.fetch_bytes(url).await?;
        Ok(String::from_utf8_lossy(&bytes).into_owned())
    }
}

impl Default for HttpClient {
    fn default() -> Self {
        Self::new().expect("failed to build HTTP client")
    }
}

// ── Xtream Codes API ──────────────────────────────────────────────────────────

/// Xtream Codes API client.
pub struct XtreamClient {
    http: HttpClient,
    base_url: String,
    username: String,
    password: String,
}

#[derive(Debug, Deserialize)]
pub struct XtreamCategory {
    pub category_id: String,
    pub category_name: String,
}

#[derive(Debug, Deserialize)]
pub struct XtreamStream {
    pub stream_id: u64,
    pub name: String,
    #[serde(default)]
    pub stream_icon: String,
    #[serde(default)]
    pub category_id: String,
    #[serde(default)]
    pub epg_channel_id: String,
    pub stream_type: Option<String>,
}

impl XtreamClient {
    pub fn new(http: HttpClient, base_url: &str, username: &str, password: &str) -> Self {
        Self {
            http,
            base_url: base_url.trim_end_matches('/').to_owned(),
            username: username.to_owned(),
            password: password.to_owned(),
        }
    }

    fn api_url(&self, action: &str) -> String {
        format!(
            "{}/player_api.php?username={}&password={}&action={}",
            self.base_url, self.username, self.password, action
        )
    }

    pub async fn get_live_categories(&self) -> Result<Vec<XtreamCategory>> {
        let url = self.api_url("get_live_categories");
        let text = self.http.fetch_text(&url).await?;
        Ok(serde_json::from_str(&text)?)
    }

    pub async fn get_live_streams(&self) -> Result<Vec<XtreamStream>> {
        let url = self.api_url("get_live_streams");
        let text = self.http.fetch_text(&url).await?;
        Ok(serde_json::from_str(&text)?)
    }

    pub fn get_epg_url(&self) -> String {
        format!(
            "{}/xmltv.php?username={}&password={}",
            self.base_url, self.username, self.password
        )
    }

    /// Build a stream URL for a live channel.
    pub fn stream_url(&self, stream_id: u64) -> String {
        format!(
            "{}/live/{}/{}/{}.ts",
            self.base_url, self.username, self.password, stream_id
        )
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn xtream_client_api_url() {
        let http = HttpClient::default();
        let client = XtreamClient::new(http, "http://xtream.example.com", "user", "pass");
        let url = client.api_url("get_live_categories");
        assert!(url.contains("username=user"));
        assert!(url.contains("password=pass"));
        assert!(url.contains("action=get_live_categories"));
    }

    #[test]
    fn xtream_client_stream_url() {
        let http = HttpClient::default();
        let client = XtreamClient::new(http, "http://xtream.example.com/", "user", "pass");
        let url = client.stream_url(42);
        assert_eq!(url, "http://xtream.example.com/live/user/pass/42.ts");
    }

    #[test]
    fn xtream_stream_deserialize() {
        let json = r#"{"stream_id":1,"name":"BBC One","stream_icon":"http://example.com/bbc.png","category_id":"1","epg_channel_id":"bbc1.uk","stream_type":"live"}"#;
        let stream: XtreamStream = serde_json::from_str(json).unwrap();
        assert_eq!(stream.name, "BBC One");
        assert_eq!(stream.stream_id, 1);
    }
}
