use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Provider {
    pub id: String,
    pub name: String,
    pub provider_type: ProviderType,
    pub url: String,
    pub credentials: Option<Credentials>,
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

impl std::fmt::Display for ProviderType {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ProviderType::M3u => write!(f, "m3u"),
            ProviderType::XtreamCodes => write!(f, "xtream_codes"),
            ProviderType::Mag => write!(f, "mag"),
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Credentials {
    pub username: String,
    pub password: String,
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
    /// Unix timestamp (seconds)
    pub start: i64,
    /// Unix timestamp (seconds)
    pub end: i64,
    pub category: Option<String>,
    pub poster_url: Option<String>,
}

impl EpgEntry {
    pub fn duration_seconds(&self) -> i64 {
        (self.end - self.start).max(0)
    }

    pub fn is_current(&self, now: i64) -> bool {
        now >= self.start && now < self.end
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Playlist {
    pub id: String,
    pub name: String,
    pub channel_ids: Vec<String>,
    pub created_at: i64,
    pub is_favorites: bool,
}

impl Playlist {
    pub fn contains(&self, channel_id: &str) -> bool {
        self.channel_ids.iter().any(|id| id == channel_id)
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct WatchHistory {
    pub channel_id: String,
    /// Unix timestamp (seconds)
    pub started_at: i64,
    pub duration_seconds: u64,
}

#[cfg(test)]
mod tests {
    use super::*;

    fn make_provider() -> Provider {
        Provider {
            id: "p1".into(),
            name: "Test Provider".into(),
            provider_type: ProviderType::M3u,
            url: "http://example.com/playlist.m3u".into(),
            credentials: None,
            epg_url: Some("http://example.com/epg.xml".into()),
            last_sync: 0,
            is_active: true,
        }
    }

    fn make_channel() -> Channel {
        Channel {
            id: "ch1".into(),
            provider_id: "p1".into(),
            name: "BBC One".into(),
            stream_url: "http://stream.example.com/bbc1.m3u8".into(),
            logo_url: Some("http://example.com/bbc1.png".into()),
            group: "News".into(),
            country: Some("UK".into()),
            languages: vec!["en".into()],
            tvg_id: Some("bbc1.uk".into()),
            catchup_support: false,
        }
    }

    fn make_epg_entry(start: i64, end: i64) -> EpgEntry {
        EpgEntry {
            channel_id: "ch1".into(),
            title: "News at Ten".into(),
            description: Some("Daily news programme".into()),
            start,
            end,
            category: Some("News".into()),
            poster_url: None,
        }
    }

    #[test]
    fn provider_serializes_round_trip() {
        let p = make_provider();
        let json = serde_json::to_string(&p).unwrap();
        let p2: Provider = serde_json::from_str(&json).unwrap();
        assert_eq!(p, p2);
    }

    #[test]
    fn channel_serializes_round_trip() {
        let ch = make_channel();
        let json = serde_json::to_string(&ch).unwrap();
        let ch2: Channel = serde_json::from_str(&json).unwrap();
        assert_eq!(ch, ch2);
    }

    #[test]
    fn provider_type_display() {
        assert_eq!(ProviderType::M3u.to_string(), "m3u");
        assert_eq!(ProviderType::XtreamCodes.to_string(), "xtream_codes");
        assert_eq!(ProviderType::Mag.to_string(), "mag");
    }

    #[test]
    fn epg_entry_duration() {
        let entry = make_epg_entry(1000, 4600);
        assert_eq!(entry.duration_seconds(), 3600);
    }

    #[test]
    fn epg_entry_duration_never_negative() {
        let entry = make_epg_entry(5000, 1000);
        assert_eq!(entry.duration_seconds(), 0);
    }

    #[test]
    fn epg_entry_is_current() {
        let entry = make_epg_entry(1000, 2000);
        assert!(entry.is_current(1500));
        assert!(!entry.is_current(999));
        assert!(!entry.is_current(2000));
    }

    #[test]
    fn playlist_contains() {
        let pl = Playlist {
            id: "pl1".into(),
            name: "Favorites".into(),
            channel_ids: vec!["ch1".into(), "ch2".into()],
            created_at: 0,
            is_favorites: true,
        };
        assert!(pl.contains("ch1"));
        assert!(!pl.contains("ch3"));
    }

    #[test]
    fn credentials_with_provider() {
        let p = Provider {
            id: "p2".into(),
            name: "Xtream".into(),
            provider_type: ProviderType::XtreamCodes,
            url: "http://xtream.example.com".into(),
            credentials: Some(Credentials {
                username: "user".into(),
                password: "pass".into(),
            }),
            epg_url: None,
            last_sync: 0,
            is_active: true,
        };
        let json = serde_json::to_string(&p).unwrap();
        let p2: Provider = serde_json::from_str(&json).unwrap();
        assert_eq!(p.credentials, p2.credentials);
    }
}
