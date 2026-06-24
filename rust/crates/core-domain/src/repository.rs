// Repository traits — implemented in issue #6
use crate::error::DomainError;
use crate::models::{Channel, EpgEntry, Playlist, Provider, WatchHistory};

pub trait ProviderRepository: Send + Sync {
    fn add(&self, provider: Provider) -> Result<Provider, DomainError>;
    fn list(&self) -> Result<Vec<Provider>, DomainError>;
    fn remove(&self, id: &str) -> Result<(), DomainError>;
    fn update(&self, provider: Provider) -> Result<Provider, DomainError>;
}

pub trait ChannelRepository: Send + Sync {
    fn upsert_all(&self, channels: Vec<Channel>) -> Result<(), DomainError>;
    fn list(&self, provider_id: Option<&str>) -> Result<Vec<Channel>, DomainError>;
    fn search(&self, query: &str) -> Result<Vec<Channel>, DomainError>;
}

pub trait EpgRepository: Send + Sync {
    fn upsert_all(&self, entries: Vec<EpgEntry>) -> Result<(), DomainError>;
    fn get_for_channel(&self, channel_id: &str, date: i64) -> Result<Vec<EpgEntry>, DomainError>;
    fn get_current(&self, channel_id: &str) -> Result<Option<EpgEntry>, DomainError>;
}

pub trait PlaylistRepository: Send + Sync {
    fn create(&self, playlist: Playlist) -> Result<Playlist, DomainError>;
    fn list(&self) -> Result<Vec<Playlist>, DomainError>;
    fn update(&self, playlist: Playlist) -> Result<Playlist, DomainError>;
    fn delete(&self, id: &str) -> Result<(), DomainError>;
}

pub trait WatchHistoryRepository: Send + Sync {
    fn record(&self, entry: WatchHistory) -> Result<(), DomainError>;
    fn recent(&self, limit: u32) -> Result<Vec<Channel>, DomainError>;
    fn most_watched(&self, limit: u32) -> Result<Vec<Channel>, DomainError>;
}
