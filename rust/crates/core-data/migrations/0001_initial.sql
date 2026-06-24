CREATE TABLE IF NOT EXISTS providers (
    id          TEXT PRIMARY KEY NOT NULL,
    name        TEXT NOT NULL,
    provider_type TEXT NOT NULL,
    url         TEXT NOT NULL,
    username    TEXT,
    password    TEXT,
    epg_url     TEXT,
    last_sync   INTEGER NOT NULL DEFAULT 0,
    is_active   INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS channels (
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
);

CREATE INDEX IF NOT EXISTS idx_channels_provider ON channels(provider_id);
CREATE INDEX IF NOT EXISTS idx_channels_group    ON channels(grp);
CREATE INDEX IF NOT EXISTS idx_channels_tvg_id   ON channels(tvg_id);

CREATE TABLE IF NOT EXISTS epg_entries (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    channel_id  TEXT NOT NULL,
    title       TEXT NOT NULL,
    description TEXT,
    start_ts    INTEGER NOT NULL,
    end_ts      INTEGER NOT NULL,
    category    TEXT,
    poster_url  TEXT
);

CREATE INDEX IF NOT EXISTS idx_epg_channel ON epg_entries(channel_id);
CREATE INDEX IF NOT EXISTS idx_epg_start   ON epg_entries(start_ts);

CREATE TABLE IF NOT EXISTS playlists (
    id          TEXT PRIMARY KEY NOT NULL,
    name        TEXT NOT NULL,
    channel_ids TEXT NOT NULL DEFAULT '[]',
    created_at  INTEGER NOT NULL,
    is_favorites INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS watch_history (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    channel_id      TEXT NOT NULL,
    started_at      INTEGER NOT NULL,
    duration_secs   INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_watch_channel ON watch_history(channel_id);
CREATE INDEX IF NOT EXISTS idx_watch_started ON watch_history(started_at DESC);
