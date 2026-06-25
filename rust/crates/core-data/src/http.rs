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
            // Fail fast when a host is unreachable, but allow a generous overall
            // budget: Xtream `get_live_streams` payloads can be ~20 MB, which on a
            // slow mobile connection easily exceeds a tight total timeout. A 30 s
            // total timeout was aborting every device sync mid-download.
            .connect_timeout(std::time::Duration::from_secs(15))
            .timeout(std::time::Duration::from_secs(120))
            .user_agent("MiPTV/0.1")
            .build()?;
        Ok(Self { inner })
    }

    /// Fetch raw bytes (used for M3U and XMLTV downloads).
    pub async fn fetch_bytes(&self, url: &str) -> Result<Vec<u8>> {
        let response = self
            .inner
            .get(url)
            .send()
            .await
            .and_then(|r| r.error_for_status())
            .map_err(|e| anyhow::anyhow!(redact_credentials(&flatten_error(&e))))?;
        let bytes = response
            .bytes()
            .await
            .map_err(|e| anyhow::anyhow!(redact_credentials(&flatten_error(&e))))?;
        Ok(bytes.to_vec())
    }

    /// Fetch UTF-8 text.
    pub async fn fetch_text(&self, url: &str) -> Result<String> {
        let bytes = self.fetch_bytes(url).await?;
        Ok(String::from_utf8_lossy(&bytes).into_owned())
    }
}

/// Flatten a reqwest error and its full source chain into a single string.
/// `reqwest::Error`'s `Display` only shows the top context (e.g. "error sending
/// request for url (…)") and hides the real cause (timeout, DNS, connection
/// reset). Walking `source()` recovers it for actionable error reporting.
fn flatten_error(e: &reqwest::Error) -> String {
    let mut msg = e.to_string();
    let mut source = std::error::Error::source(e);
    while let Some(s) = source {
        msg.push_str(": ");
        msg.push_str(&s.to_string());
        source = s.source();
    }
    msg
}

/// Mask `username`/`password` query-param values so credentials never leak into
/// logs or error messages (reqwest embeds the full request URL in its errors).
fn redact_credentials(text: &str) -> String {
    let mut out = text.to_string();
    for key in ["password", "username"] {
        out = mask_param(&out, key);
    }
    out
}

fn mask_param(text: &str, key: &str) -> String {
    let needle = format!("{key}=");
    let mut result = String::with_capacity(text.len());
    let mut rest = text;
    while let Some(pos) = rest.find(&needle) {
        let (before, after) = rest.split_at(pos + needle.len());
        result.push_str(before);
        result.push_str("***");
        let end = after
            .find(|c: char| c == '&' || c == ')' || c.is_whitespace())
            .unwrap_or(after.len());
        rest = &after[end..];
    }
    result.push_str(rest);
    result
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
    #[serde(deserialize_with = "null_as_default")]
    pub category_id: String,
    #[serde(deserialize_with = "null_as_default")]
    pub category_name: String,
}

fn null_as_default<'de, D, T>(d: D) -> Result<T, D::Error>
where
    D: serde::Deserializer<'de>,
    T: Default + Deserialize<'de>,
{
    Ok(Option::<T>::deserialize(d)?.unwrap_or_default())
}

#[derive(Debug, Deserialize)]
pub struct XtreamStream {
    pub stream_id: u64,
    #[serde(deserialize_with = "null_as_default")]
    pub name: String,
    #[serde(default, deserialize_with = "null_as_default")]
    pub stream_icon: String,
    #[serde(default, deserialize_with = "null_as_default")]
    pub category_id: String,
    #[serde(default, deserialize_with = "null_as_default")]
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
        let bytes = self.http.fetch_bytes(&url).await?;
        Ok(serde_json::from_slice(&bytes)?)
    }

    pub async fn get_live_streams(&self) -> Result<Vec<XtreamStream>> {
        let url = self.api_url("get_live_streams");
        // Parse straight from bytes to avoid a second ~20 MB UTF-8 copy.
        let bytes = self.http.fetch_bytes(&url).await?;
        Ok(serde_json::from_slice(&bytes)?)
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
