import Foundation
import MiPTVCore // UniFFI-generated Swift bindings

// Thin Swift wrapper over the UniFFI MiPTVCore object.
// This class is registered as a React Native Turbo Native Module
// via NativeMiPTVCore.mm (ObjC++ bridge).
@objc(NativeMiPTVCore)
class NativeMiPTVCore: NSObject {

    private var core: MiPTVCore?

    @objc static func requiresMainQueueSetup() -> Bool { false }

    // MARK: - Lifecycle

    @objc func initialize(_ dbPath: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        Task {
            do {
                self.core = try await MiPTVCore.init(dbPath: dbPath)
                resolve(nil)
            } catch {
                reject("INIT_ERROR", error.localizedDescription, error)
            }
        }
    }

    // MARK: - Providers

    @objc func addProvider(_ provider: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let core else { reject("NOT_INIT", "Call init first", nil); return }
        Task {
            do {
                let ffi = FfiProvider(from: provider)
                try await core.addProvider(provider: ffi)
                resolve(nil)
            } catch { reject("DB_ERROR", error.localizedDescription, error) }
        }
    }

    @objc func listProviders(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let core else { reject("NOT_INIT", "Call init first", nil); return }
        Task {
            do {
                let providers = try await core.listProviders()
                resolve(providers.map { $0.toDict() })
            } catch { reject("DB_ERROR", error.localizedDescription, error) }
        }
    }

    @objc func deleteProvider(_ id: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let core else { reject("NOT_INIT", "Call init first", nil); return }
        Task {
            do {
                try await core.deleteProvider(id: id)
                resolve(nil)
            } catch { reject("DB_ERROR", error.localizedDescription, error) }
        }
    }

    @objc func syncProvider(_ providerId: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let core else { reject("NOT_INIT", "Call init first", nil); return }
        Task {
            do {
                let count = try await core.syncProvider(providerId: providerId)
                resolve(count)
            } catch { reject("SYNC_ERROR", error.localizedDescription, error) }
        }
    }

    // MARK: - Channels

    @objc func listChannels(_ providerId: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let core else { reject("NOT_INIT", "Call init first", nil); return }
        Task {
            do {
                let channels = try await core.listChannels(providerId: providerId)
                resolve(channels.map { $0.toDict() })
            } catch { reject("DB_ERROR", error.localizedDescription, error) }
        }
    }

    @objc func searchChannels(_ query: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let core else { reject("NOT_INIT", "Call init first", nil); return }
        Task {
            do {
                let channels = try await core.searchChannels(query: query)
                resolve(channels.map { $0.toDict() })
            } catch { reject("DB_ERROR", error.localizedDescription, error) }
        }
    }

    // MARK: - EPG

    @objc func getCurrentEpg(_ channelId: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let core else { reject("NOT_INIT", "Call init first", nil); return }
        Task {
            do {
                let entry = try await core.getCurrentEpg(channelId: channelId)
                resolve(entry?.toDict())
            } catch { reject("DB_ERROR", error.localizedDescription, error) }
        }
    }

    @objc func getEpgForChannel(_ channelId: String, start: Double, end: Double, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let core else { reject("NOT_INIT", "Call init first", nil); return }
        Task {
            do {
                let entries = try await core.getEpgForChannel(channelId: channelId, start: Int64(start), end: Int64(end))
                resolve(entries.map { $0.toDict() })
            } catch { reject("DB_ERROR", error.localizedDescription, error) }
        }
    }

    // MARK: - Playlists

    @objc func createPlaylist(_ playlist: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let core else { reject("NOT_INIT", "Call init first", nil); return }
        Task {
            do {
                let ffi = FfiPlaylist(from: playlist)
                try await core.createPlaylist(playlist: ffi)
                resolve(nil)
            } catch { reject("DB_ERROR", error.localizedDescription, error) }
        }
    }

    @objc func listPlaylists(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let core else { reject("NOT_INIT", "Call init first", nil); return }
        Task {
            do {
                let playlists = try await core.listPlaylists()
                resolve(playlists.map { $0.toDict() })
            } catch { reject("DB_ERROR", error.localizedDescription, error) }
        }
    }

    @objc func deletePlaylist(_ id: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let core else { reject("NOT_INIT", "Call init first", nil); return }
        Task {
            do {
                try await core.deletePlaylist(id: id)
                resolve(nil)
            } catch { reject("DB_ERROR", error.localizedDescription, error) }
        }
    }

    // MARK: - Watch History

    @objc func recordWatch(_ channelId: String, startedAt: Double, durationSeconds: Double, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let core else { reject("NOT_INIT", "Call init first", nil); return }
        Task {
            do {
                try await core.recordWatch(channelId: channelId, startedAt: Int64(startedAt), durationSeconds: UInt64(durationSeconds))
                resolve(nil)
            } catch { reject("DB_ERROR", error.localizedDescription, error) }
        }
    }
}

// MARK: - UniFFI ↔ NSDictionary helpers

private extension FfiProvider {
    init(from dict: NSDictionary) {
        self.init(
            id: dict["id"] as? String ?? "",
            name: dict["name"] as? String ?? "",
            providerType: dict["providerType"] as? String ?? "m3u",
            url: dict["url"] as? String ?? "",
            username: dict["username"] as? String,
            password: dict["password"] as? String,
            epgUrl: dict["epgUrl"] as? String,
            lastSync: dict["lastSync"] as? Int64 ?? 0,
            isActive: dict["isActive"] as? Bool ?? true
        )
    }

    func toDict() -> NSDictionary {
        [
            "id": id, "name": name, "providerType": providerType,
            "url": url, "username": username as Any, "password": password as Any,
            "epgUrl": epgUrl as Any, "lastSync": lastSync, "isActive": isActive,
        ]
    }
}

private extension FfiChannel {
    func toDict() -> NSDictionary {
        [
            "id": id, "providerId": providerId, "name": name,
            "streamUrl": streamUrl, "logoUrl": logoUrl as Any,
            "group": group, "country": country as Any,
            "tvgId": tvgId as Any, "catchupSupport": catchupSupport,
        ]
    }
}

private extension FfiEpgEntry {
    func toDict() -> NSDictionary {
        [
            "channelId": channelId, "title": title,
            "description": description as Any,
            "start": start, "end": end,
            "category": category as Any, "posterUrl": posterUrl as Any,
        ]
    }
}

private extension FfiPlaylist {
    init(from dict: NSDictionary) {
        self.init(
            id: dict["id"] as? String ?? "",
            name: dict["name"] as? String ?? "",
            channelIds: dict["channelIds"] as? [String] ?? [],
            createdAt: dict["createdAt"] as? Int64 ?? 0,
            isFavorites: dict["isFavorites"] as? Bool ?? false
        )
    }

    func toDict() -> NSDictionary {
        [
            "id": id, "name": name,
            "channelIds": channelIds,
            "createdAt": createdAt,
            "isFavorites": isFavorites,
        ]
    }
}
