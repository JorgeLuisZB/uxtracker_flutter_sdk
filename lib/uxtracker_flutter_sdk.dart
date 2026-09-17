/// UxTracker product analytics for Flutter.
///
/// A thin wrapper over the native UxTracker Android and iOS SDKs: queueing, persistence, retries, sessions and
/// identity all happen natively (ingestion protocol §10.6).
library;

export 'src/config.dart' show UxTrackerConfig;
export 'src/ux_tracker.dart' show UxTracker;
