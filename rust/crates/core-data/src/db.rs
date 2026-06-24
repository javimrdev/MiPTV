use anyhow::Result;
use core_domain::models::{Channel, Credentials, EpgEntry, Playlist, Provider, ProviderType, WatchHistory};
use sqlx::{sqlite::SqlitePoolOptions, FromRow, SqlitePool};

pub struct Database {
    pool: SqlitePool,
}

// ── Row types (FromRow avoids the query! macro / DATABASE_URL requirement) ──

#[derive(Debug, FromRow)]
struct ProviderRow {
    id: String,
    name: String,
    provider_type: String,
    url: String,
    username: Option<String>,
    password: Option<String>,
    epg_url: Option<String>,
    last_sync: i64,
    is_active: i64,
}

#[derive(Debug, FromRow)]
struct ChannelRow {
    id: String,
    provider_id: String,
    name: String,
    stream_url: String,
    logo_url: Option<String>,
    grp: String,
    country: Option<String>,
    languages: String,
    tvg_id: Option<String>,
    catchup_support: i64,
}

#[derive(Debug, FromRow)]
struct EpgRow {
    channel_id: String,
    title: String,
    description: Option<String>,
    start_ts: i64,
    end_ts: i64,
    category: Option<String>,
    poster_url: Option<String>,
}

#[derive(Debug, FromRow)]
struct PlaylistRow {
    id: String,
    name: String,
    channel_ids: String,
    created_at: i64,
    is_favorites: i64,
}

impl Database {
    pub async fn open(path: &str) -> Result<Self> {
        let url = if path == ":memory:" {
            "sqlite::memory:".to_string()
        } else {
            format!("sqlite:{path}?mode=rwc")
        };

        let pool = SqlitePoolOptions::new().max_connections(4).connect(&url).await?;

        sqlx::query(
            "CREATE TABLE IF NOT EXISTS providers (
                id            TEXT PRIMARY KEY NOT NULL,
                name          TEXT NOT NULL,
                provider_type TEXT NOT NULL,
                url           TEXT NOT NULL,
                username      TEXT,
                password      TEXT,
                epg_url       TEXT,
                last_sync     INTEGER NOT NULL DEFAULT 0,
                is_active     INTEGER NOT NULL DEFAULT 1
            )",
        )
        .execute(&pool)
        .await?;

        sqlx::query(
            "CREATE TABLE IF NOT EXISTS channels (
                id              TEXT PRIMARY KEY NOT NULL,
                provider_id     TEXT NOT NULL REFERENCES providers(id) ON DELETE CASCADE,
                name            TEXT NOT NULL,
                stream_url      TEXT NOT NULL,
                logo_url        TEXT,
                grp             TEXT NOT NULL DEFAULT 'Uncategorized',
                country         TEXT,
                languages       TEXT NOT NULL DEFAULT '[]',
                tvg_id          TEXT,
                catchup_support INTEGER NOT NULL DEFAULT 0
            )",
        )
        .execute(&pool)
        .await?;

        sqlx::query(
            "CREATE INDEX IF NOT EXISTS idx_channels_provider ON channels(provider_id)",
        )
        .execute(&pool)
        .await?;

        sqlx::query(
            "CREATE TABLE IF NOT EXISTS epg_entries (
                id          INTEGER PRIMARY KEY AUTOINCREMENT,
                channel_id  TEXT NOT NULL,
                title       TEXT NOT NULL,
                description TEXT,
                start_ts    INTEGER NOT NULL,
                end_ts      INTEGER NOT NULL,
                category    TEXT,
                poster_url  TEXT
            )",
        )
        .execute(&pool)
        .await?;

        sqlx::query(
            "CREATE INDEX IF NOT EXISTS idx_epg_channel ON epg_entries(channel_id)",
        )
        .execute(&pool)
        .await?;

        sqlx::query(
            "CREATE TABLE IF NOT EXISTS playlists (
                id           TEXT PRIMARY KEY NOT NULL,
                name         TEXT NOT NULL,
                channel_ids  TEXT NOT NULL DEFAULT '[]',
                created_at   INTEGER NOT NULL,
                is_favorites INTEGER NOT NULL DEFAULT 0
            )",
        )
        .execute(&pool)
        .await?;

        sqlx::query(
            "CREATE TABLE IF NOT EXISTS watch_history (
                id            INTEGER PRIMARY KEY AUTOINCREMENT,
                channel_id    TEXT NOT NULL,
                started_at    INTEGER NOT NULL,
                duration_secs INTEGER NOT NULL DEFAULT 0
            )",
        )
        .execute(&pool)
        .await?;

        Ok(Self { pool })
    }

    // ── Providers ─────────────────────────────────────────────────────────────

    pub async fn insert_provider(&self, p: &Provider) -> Result<()> {
        let provider_type = p.provider_type.to_string();
        let username = p.credentials.as_ref().map(|c| c.username.as_str());
        let password = p.credentials.as_ref().map(|c| c.password.as_str());
        let is_active = p.is_active as i64;

        sqlx::query(
            "INSERT OR REPLACE INTO providers
             (id, name, provider_type, url, username, password, epg_url, last_sync, is_active)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        )
        .bind(&p.id)
        .bind(&p.name)
        .bind(&provider_type)
        .bind(&p.url)
        .bind(username)
        .bind(password)
        .bind(&p.epg_url)
        .bind(p.last_sync)
        .bind(is_active)
        .execute(&self.pool)
        .await?;

        Ok(())
    }

    pub async fn list_providers(&self) -> Result<Vec<Provider>> {
        let rows: Vec<ProviderRow> = sqlx::query_as(
            "SELECT id, name, provider_type, url, username, password, epg_url, last_sync, is_active
             FROM providers",
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(rows.into_iter().map(provider_from_row).collect())
    }

    pub async fn delete_provider(&self, id: &str) -> Result<()> {
        sqlx::query("DELETE FROM providers WHERE id = ?")
            .bind(id)
            .execute(&self.pool)
            .await?;
        Ok(())
    }

    // ── Channels ──────────────────────────────────────────────────────────────

    pub async fn upsert_channels(&self, channels: &[Channel]) -> Result<()> {
        let mut tx = self.pool.begin().await?;
        for ch in channels {
            let languages = serde_json::to_string(&ch.languages)?;
            let catchup = ch.catchup_support as i64;
            sqlx::query(
                "INSERT OR REPLACE INTO channels
                 (id, provider_id, name, stream_url, logo_url, grp, country, languages, tvg_id, catchup_support)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            )
            .bind(&ch.id)
            .bind(&ch.provider_id)
            .bind(&ch.name)
            .bind(&ch.stream_url)
            .bind(&ch.logo_url)
            .bind(&ch.group)
            .bind(&ch.country)
            .bind(&languages)
            .bind(&ch.tvg_id)
            .bind(catchup)
            .execute(&mut *tx)
            .await?;
        }
        tx.commit().await?;
        Ok(())
    }

    pub async fn list_channels(&self, provider_id: Option<&str>) -> Result<Vec<Channel>> {
        let rows: Vec<ChannelRow> = if let Some(pid) = provider_id {
            sqlx::query_as(
                "SELECT id, provider_id, name, stream_url, logo_url, grp, country, languages, tvg_id, catchup_support
                 FROM channels WHERE provider_id = ? ORDER BY grp, name",
            )
            .bind(pid)
            .fetch_all(&self.pool)
            .await?
        } else {
            sqlx::query_as(
                "SELECT id, provider_id, name, stream_url, logo_url, grp, country, languages, tvg_id, catchup_support
                 FROM channels ORDER BY grp, name",
            )
            .fetch_all(&self.pool)
            .await?
        };

        Ok(rows.into_iter().map(channel_from_row).collect())
    }

    pub async fn search_channels(&self, query: &str) -> Result<Vec<Channel>> {
        let pattern = format!("%{query}%");
        let rows: Vec<ChannelRow> = sqlx::query_as(
            "SELECT id, provider_id, name, stream_url, logo_url, grp, country, languages, tvg_id, catchup_support
             FROM channels WHERE name LIKE ? OR grp LIKE ? ORDER BY name LIMIT 200",
        )
        .bind(&pattern)
        .bind(&pattern)
        .fetch_all(&self.pool)
        .await?;

        Ok(rows.into_iter().map(channel_from_row).collect())
    }

    // ── EPG ───────────────────────────────────────────────────────────────────

    pub async fn upsert_epg_entries(&self, entries: &[EpgEntry]) -> Result<()> {
        let mut tx = self.pool.begin().await?;
        for e in entries {
            sqlx::query(
                "INSERT INTO epg_entries (channel_id, title, description, start_ts, end_ts, category, poster_url)
                 VALUES (?, ?, ?, ?, ?, ?, ?)",
            )
            .bind(&e.channel_id)
            .bind(&e.title)
            .bind(&e.description)
            .bind(e.start)
            .bind(e.end)
            .bind(&e.category)
            .bind(&e.poster_url)
            .execute(&mut *tx)
            .await?;
        }
        tx.commit().await?;
        Ok(())
    }

    pub async fn get_epg_for_channel(
        &self,
        channel_id: &str,
        date_start: i64,
        date_end: i64,
    ) -> Result<Vec<EpgEntry>> {
        let rows: Vec<EpgRow> = sqlx::query_as(
            "SELECT channel_id, title, description, start_ts, end_ts, category, poster_url
             FROM epg_entries WHERE channel_id = ? AND end_ts >= ? AND start_ts <= ?
             ORDER BY start_ts",
        )
        .bind(channel_id)
        .bind(date_start)
        .bind(date_end)
        .fetch_all(&self.pool)
        .await?;

        Ok(rows.into_iter().map(epg_from_row).collect())
    }

    pub async fn get_current_epg(&self, channel_id: &str, now: i64) -> Result<Option<EpgEntry>> {
        let row: Option<EpgRow> = sqlx::query_as(
            "SELECT channel_id, title, description, start_ts, end_ts, category, poster_url
             FROM epg_entries WHERE channel_id = ? AND start_ts <= ? AND end_ts > ?
             ORDER BY start_ts DESC LIMIT 1",
        )
        .bind(channel_id)
        .bind(now)
        .bind(now)
        .fetch_optional(&self.pool)
        .await?;

        Ok(row.map(epg_from_row))
    }

    // ── Playlists ─────────────────────────────────────────────────────────────

    pub async fn insert_playlist(&self, pl: &Playlist) -> Result<()> {
        let channel_ids = serde_json::to_string(&pl.channel_ids)?;
        let is_favorites = pl.is_favorites as i64;
        sqlx::query(
            "INSERT OR REPLACE INTO playlists (id, name, channel_ids, created_at, is_favorites)
             VALUES (?, ?, ?, ?, ?)",
        )
        .bind(&pl.id)
        .bind(&pl.name)
        .bind(&channel_ids)
        .bind(pl.created_at)
        .bind(is_favorites)
        .execute(&self.pool)
        .await?;
        Ok(())
    }

    pub async fn list_playlists(&self) -> Result<Vec<Playlist>> {
        let rows: Vec<PlaylistRow> =
            sqlx::query_as("SELECT id, name, channel_ids, created_at, is_favorites FROM playlists")
                .fetch_all(&self.pool)
                .await?;

        Ok(rows.into_iter().map(playlist_from_row).collect())
    }

    pub async fn delete_playlist(&self, id: &str) -> Result<()> {
        sqlx::query("DELETE FROM playlists WHERE id = ?")
            .bind(id)
            .execute(&self.pool)
            .await?;
        Ok(())
    }

    // ── Watch History ─────────────────────────────────────────────────────────

    pub async fn record_watch(&self, entry: &WatchHistory) -> Result<()> {
        sqlx::query(
            "INSERT INTO watch_history (channel_id, started_at, duration_secs) VALUES (?, ?, ?)",
        )
        .bind(&entry.channel_id)
        .bind(entry.started_at)
        .bind(entry.duration_seconds as i64)
        .execute(&self.pool)
        .await?;
        Ok(())
    }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

fn parse_provider_type(s: &str) -> ProviderType {
    match s {
        "xtream_codes" => ProviderType::XtreamCodes,
        "mag" => ProviderType::Mag,
        _ => ProviderType::M3u,
    }
}

fn provider_from_row(r: ProviderRow) -> Provider {
    Provider {
        id: r.id,
        name: r.name,
        provider_type: parse_provider_type(&r.provider_type),
        url: r.url,
        credentials: match (r.username, r.password) {
            (Some(u), Some(pw)) => Some(Credentials {
                username: u,
                password: pw,
            }),
            _ => None,
        },
        epg_url: r.epg_url,
        last_sync: r.last_sync,
        is_active: r.is_active != 0,
    }
}

fn channel_from_row(r: ChannelRow) -> Channel {
    Channel {
        id: r.id,
        provider_id: r.provider_id,
        name: r.name,
        stream_url: r.stream_url,
        logo_url: r.logo_url,
        group: r.grp,
        country: r.country,
        languages: serde_json::from_str(&r.languages).unwrap_or_default(),
        tvg_id: r.tvg_id,
        catchup_support: r.catchup_support != 0,
    }
}

fn epg_from_row(r: EpgRow) -> EpgEntry {
    EpgEntry {
        channel_id: r.channel_id,
        title: r.title,
        description: r.description,
        start: r.start_ts,
        end: r.end_ts,
        category: r.category,
        poster_url: r.poster_url,
    }
}

fn playlist_from_row(r: PlaylistRow) -> Playlist {
    Playlist {
        id: r.id,
        name: r.name,
        channel_ids: serde_json::from_str(&r.channel_ids).unwrap_or_default(),
        created_at: r.created_at,
        is_favorites: r.is_favorites != 0,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    async fn in_memory_db() -> Database {
        Database::open(":memory:").await.expect("in-memory db")
    }

    fn make_provider() -> Provider {
        Provider {
            id: "p1".into(),
            name: "Test".into(),
            provider_type: ProviderType::M3u,
            url: "http://example.com/list.m3u".into(),
            credentials: None,
            epg_url: None,
            last_sync: 0,
            is_active: true,
        }
    }

    fn make_channel(id: &str, provider_id: &str) -> Channel {
        Channel {
            id: id.into(),
            provider_id: provider_id.into(),
            name: format!("Channel {id}"),
            stream_url: format!("http://stream.example.com/{id}.m3u8"),
            logo_url: None,
            group: "News".into(),
            country: None,
            languages: vec!["en".into()],
            tvg_id: Some(id.into()),
            catchup_support: false,
        }
    }

    #[tokio::test]
    async fn provider_insert_and_list() {
        let db = in_memory_db().await;
        db.insert_provider(&make_provider()).await.unwrap();
        let providers = db.list_providers().await.unwrap();
        assert_eq!(providers.len(), 1);
        assert_eq!(providers[0].id, "p1");
    }

    #[tokio::test]
    async fn provider_delete() {
        let db = in_memory_db().await;
        db.insert_provider(&make_provider()).await.unwrap();
        db.delete_provider("p1").await.unwrap();
        assert!(db.list_providers().await.unwrap().is_empty());
    }

    #[tokio::test]
    async fn channel_upsert_and_list() {
        let db = in_memory_db().await;
        db.insert_provider(&make_provider()).await.unwrap();
        let channels = vec![make_channel("ch1", "p1"), make_channel("ch2", "p1")];
        db.upsert_channels(&channels).await.unwrap();
        let result = db.list_channels(Some("p1")).await.unwrap();
        assert_eq!(result.len(), 2);
    }

    #[tokio::test]
    async fn channel_search() {
        let db = in_memory_db().await;
        db.insert_provider(&make_provider()).await.unwrap();
        db.upsert_channels(&[make_channel("bbc1", "p1"), make_channel("cnn", "p1")])
            .await
            .unwrap();
        let result = db.search_channels("bbc").await.unwrap();
        assert_eq!(result.len(), 1);
        assert_eq!(result[0].id, "bbc1");
    }

    #[tokio::test]
    async fn playlist_crud() {
        let db = in_memory_db().await;
        let pl = Playlist {
            id: "fav".into(),
            name: "Favorites".into(),
            channel_ids: vec!["ch1".into()],
            created_at: 0,
            is_favorites: true,
        };
        db.insert_playlist(&pl).await.unwrap();
        let lists = db.list_playlists().await.unwrap();
        assert_eq!(lists.len(), 1);
        assert_eq!(lists[0].channel_ids, vec!["ch1"]);
        db.delete_playlist("fav").await.unwrap();
        assert!(db.list_playlists().await.unwrap().is_empty());
    }
}
