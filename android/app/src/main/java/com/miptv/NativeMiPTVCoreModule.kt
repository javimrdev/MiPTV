package com.miptv

import com.facebook.react.bridge.*
import kotlinx.coroutines.*
import uniffi.ffi_uniffi.CoreError
import uniffi.ffi_uniffi.FfiPlaylist
import uniffi.ffi_uniffi.FfiProvider
import uniffi.ffi_uniffi.MiPTVCore

class NativeMiPTVCoreModule(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {

    private val scope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private var core: MiPTVCore? = null

    override fun getName() = "NativeMiPTVCore"

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    @ReactMethod
    fun initialize(dbPath: String, promise: Promise) {
        val resolvedPath = if (dbPath.startsWith("/") || dbPath == ":memory:") {
            dbPath
        } else {
            reactApplicationContext.filesDir.resolve(dbPath).absolutePath
        }
        scope.launch {
            try {
                core = MiPTVCore.init(resolvedPath)
                promise.resolve(null)
            } catch (e: CoreError) {
                promise.reject("INIT_ERROR", e.message, e)
            }
        }
    }

    // ── Providers ─────────────────────────────────────────────────────────────

    @ReactMethod
    fun addProvider(provider: ReadableMap, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                c.addProvider(provider.toFfiProvider())
                promise.resolve(null)
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    @ReactMethod
    fun listProviders(promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                val list = c.listProviders()
                promise.resolve(list.toWritableArray { it.toWritableMap() })
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    @ReactMethod
    fun deleteProvider(id: String, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                c.deleteProvider(id)
                promise.resolve(null)
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    @ReactMethod
    fun syncProvider(providerId: String, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                val count = c.syncProvider(providerId)
                promise.resolve(count.toDouble())
            } catch (e: CoreError) {
                promise.reject("SYNC_ERROR", e.message, e)
            }
        }
    }

    // ── Channels ──────────────────────────────────────────────────────────────

    @ReactMethod
    fun listChannels(providerId: String, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                val list = c.listChannels(providerId)
                promise.resolve(list.toWritableArray { it.toWritableMap() })
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    @ReactMethod
    fun searchChannels(query: String, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                val list = c.searchChannels(query)
                promise.resolve(list.toWritableArray { it.toWritableMap() })
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    // ── EPG ───────────────────────────────────────────────────────────────────

    @ReactMethod
    fun syncEpg(providerId: String, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                val count = c.syncEpg(providerId)
                promise.resolve(count.toDouble())
            } catch (e: CoreError) {
                promise.reject("SYNC_ERROR", e.message, e)
            }
        }
    }

    @ReactMethod
    fun getCurrentEpg(channelId: String, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                val entry = c.getCurrentEpg(channelId)
                promise.resolve(entry?.toWritableMap())
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    @ReactMethod
    fun getEpgForChannel(channelId: String, start: Double, end: Double, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                val list = c.getEpgForChannel(channelId, start.toLong(), end.toLong())
                promise.resolve(list.toWritableArray { it.toWritableMap() })
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    // ── Playlists ─────────────────────────────────────────────────────────────

    @ReactMethod
    fun createPlaylist(playlist: ReadableMap, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                c.createPlaylist(playlist.toFfiPlaylist())
                promise.resolve(null)
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    @ReactMethod
    fun listPlaylists(promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                val list = c.listPlaylists()
                promise.resolve(list.toWritableArray { it.toWritableMap() })
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    @ReactMethod
    fun updatePlaylist(playlist: ReadableMap, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                c.updatePlaylist(playlist.toFfiPlaylist())
                promise.resolve(null)
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    @ReactMethod
    fun deletePlaylist(id: String, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                c.deletePlaylist(id)
                promise.resolve(null)
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    // ── Watch History ─────────────────────────────────────────────────────────

    @ReactMethod
    fun recordWatch(channelId: String, startedAt: Double, durationSeconds: Double, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                c.recordWatch(channelId, startedAt.toLong(), durationSeconds.toULong())
                promise.resolve(null)
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    @ReactMethod
    fun getRecentlyWatched(limit: Double, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                val list = c.getRecentlyWatched(limit.toULong())
                promise.resolve(list.toWritableArray { it.toWritableMap() })
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    @ReactMethod
    fun getMostWatched(limit: Double, promise: Promise) {
        val c = core ?: return promise.reject("NOT_INIT", "Call init first", null)
        scope.launch {
            try {
                val list = c.getMostWatched(limit.toULong())
                promise.resolve(list.toWritableArray { it.toWritableMap() })
            } catch (e: CoreError) {
                promise.reject("DB_ERROR", e.message, e)
            }
        }
    }

    // ── ReadableMap helpers ───────────────────────────────────────────────────

    private fun ReadableMap.toFfiProvider() = FfiProvider(
        id = getString("id") ?: "",
        name = getString("name") ?: "",
        providerType = getString("providerType") ?: "m3u",
        url = getString("url") ?: "",
        username = if (hasKey("username")) getString("username") else null,
        password = if (hasKey("password")) getString("password") else null,
        epgUrl = if (hasKey("epgUrl")) getString("epgUrl") else null,
        lastSync = if (hasKey("lastSync")) getDouble("lastSync").toLong() else 0L,
        isActive = if (hasKey("isActive")) getBoolean("isActive") else true,
    )

    private fun ReadableMap.toFfiPlaylist() = FfiPlaylist(
        id = getString("id") ?: "",
        name = getString("name") ?: "",
        channelIds = getArray("channelIds")?.toArrayList()?.filterIsInstance<String>() ?: emptyList(),
        createdAt = if (hasKey("createdAt")) getDouble("createdAt").toLong() else 0L,
        isFavorites = if (hasKey("isFavorites")) getBoolean("isFavorites") else false,
    )
}

// ── WritableMap extensions ────────────────────────────────────────────────────

private fun uniffi.ffi_uniffi.FfiProvider.toWritableMap(): WritableMap =
    Arguments.createMap().apply {
        putString("id", id); putString("name", name)
        putString("providerType", providerType); putString("url", url)
        username?.let { putString("username", it) } ?: putNull("username")
        password?.let { putString("password", it) } ?: putNull("password")
        epgUrl?.let { putString("epgUrl", it) } ?: putNull("epgUrl")
        putDouble("lastSync", lastSync.toDouble()); putBoolean("isActive", isActive)
    }

private fun uniffi.ffi_uniffi.FfiChannel.toWritableMap(): WritableMap =
    Arguments.createMap().apply {
        putString("id", id); putString("providerId", providerId)
        putString("name", name); putString("streamUrl", streamUrl)
        logoUrl?.let { putString("logoUrl", it) } ?: putNull("logoUrl")
        putString("group", group)
        country?.let { putString("country", it) } ?: putNull("country")
        tvgId?.let { putString("tvgId", it) } ?: putNull("tvgId")
        putBoolean("catchupSupport", catchupSupport)
    }

private fun uniffi.ffi_uniffi.FfiEpgEntry.toWritableMap(): WritableMap =
    Arguments.createMap().apply {
        putString("channelId", channelId); putString("title", title)
        description?.let { putString("description", it) } ?: putNull("description")
        putDouble("start", start.toDouble()); putDouble("end", end.toDouble())
        category?.let { putString("category", it) } ?: putNull("category")
        posterUrl?.let { putString("posterUrl", it) } ?: putNull("posterUrl")
    }

private fun uniffi.ffi_uniffi.FfiPlaylist.toWritableMap(): WritableMap =
    Arguments.createMap().apply {
        putString("id", id); putString("name", name)
        putArray("channelIds", Arguments.fromList(channelIds))
        putDouble("createdAt", createdAt.toDouble())
        putBoolean("isFavorites", isFavorites)
    }

private fun <T> List<T>.toWritableArray(transform: (T) -> WritableMap): WritableArray =
    Arguments.createArray().also { arr -> forEach { arr.pushMap(transform(it)) } }
