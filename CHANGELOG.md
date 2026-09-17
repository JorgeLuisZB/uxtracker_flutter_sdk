## 1.0.0-beta.1

- Rewritten as a thin wrapper over the native UxTracker Android and iOS SDKs 1.0.0-beta.1 (ingestion protocol v1).
- New API: `UxTracker.initialize(UxTrackerConfig)`, `track`, `screen`, `identify`, `group`, `unsetGroup`,
  `register`, `unregister`, `reset`, `flush`, `optOut`, `optIn`, `isOptedOut`, `distinctId`.
- Breaking: replaces the 0.0.x `UxtrackerFlutterSdk` API and `UxTrackerSetup`.
