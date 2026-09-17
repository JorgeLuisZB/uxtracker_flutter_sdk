/// SDK configuration (ingestion protocol §10.1).
///
/// ```dart
/// const config = UxTrackerConfig(
///   writeKey: 'uxt_pk_live_mx_…',
///   serverUrl: 'https://ingest.mx.example.com',
/// );
/// ```
class UxTrackerConfig {
  const UxTrackerConfig({
    required this.writeKey,
    required this.serverUrl,
    this.flushIntervalSeconds = 30,
    this.flushAt = 20,
    this.maxQueueSize = 10000,
    this.sessionTimeoutSeconds = 1800,
    this.trackAppLifecycle = true,
    this.optOutByDefault = false,
    this.debug = false,
  });

  /// Project write key (`uxt_pk_…`). Public by design: it can only send data.
  final String writeKey;

  /// Ingestion host of the project's region. `https://` is required unless [debug] is on.
  final String serverUrl;

  /// Seconds between automatic flushes. Minimum 5.
  final int flushIntervalSeconds;

  /// Flush as soon as this many events are queued. 1–100.
  final int flushAt;

  /// Queue capacity; the oldest events are dropped beyond it. Minimum 100.
  final int maxQueueSize;

  /// Seconds in background after which returning to the app starts a new session. Minimum 60.
  final int sessionTimeoutSeconds;

  /// Sends `$app_installed`, `$app_updated`, `$app_opened` and `$app_backgrounded` automatically.
  final bool trackAppLifecycle;

  /// Starts opted out until [UxTracker.optIn] is called, for apps that ask for consent first.
  final bool optOutByDefault;

  /// Verbose native logs, and allows `http://` servers for local development.
  final bool debug;

  Map<String, Object?> toMap() => {
        'writeKey': writeKey,
        'serverUrl': serverUrl,
        'flushIntervalSeconds': flushIntervalSeconds,
        'flushAt': flushAt,
        'maxQueueSize': maxQueueSize,
        'sessionTimeoutSeconds': sessionTimeoutSeconds,
        'trackAppLifecycle': trackAppLifecycle,
        'optOutByDefault': optOutByDefault,
        'debug': debug,
      };
}
