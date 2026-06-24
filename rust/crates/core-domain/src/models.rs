// Domain models — fully implemented in issue #3
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Provider {
    pub id: String,
    pub name: String,
    pub provider_type: ProviderType,
    pub url: String,
    pub epg_url: Option<String>,
    pub last_sync: i64,
    pub is_active: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[serde(rename_all = "snake_case")]
pub enum ProviderType {
    M3u,
    XtreamCodes,
    Mag,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Channel {
    pub id: String,
    pub provider_id: String,
    pub name: String,
    pub stream_url: String,
    pub logo_url: Option<String>,
    pub group: String,
    pub country: Option<String>,
    pub languages: Vec<String>,
    pub tvg_id: Option<String>,
    pub catchup_support: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct EpgEntry {
    pub channel_id: String,
    pub title: String,
    pub description: Option<String>,
    pub start: i64,
    pub end: i64,
    pub category: Option<String>,
    pub poster_url: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Playlist {
    pub id: String,
    pub name: String,
    pub channel_ids: Vec<String>,
    pub created_at: i64,
    pub is_favorites: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct WatchHistory {
    pub channel_id: String,
    pub started_at: i64,
    pub duration_seconds: u64,
}
