import 'config.dart';
import 'platform_interface.dart';
import 'values.dart';

/// UxTracker for Flutter. Initialize once, as early as possible:
///
/// ```dart
/// await UxTracker.initialize(const UxTrackerConfig(writeKey: writeKey, serverUrl: serverUrl));
/// UxTracker.track('Menu day selected', properties: {'day': 'monday'});
/// ```
///
/// Calls don't need to be awaited and never throw. Calls made before [initialize] are kept (up to 1,000)
/// by the native SDK and applied once it runs.
class UxTracker {
  UxTracker._();

  /// This plugin's version, reported as `context.library` with the native SDK as `library.core`.
  static const String version = '1.0.0-beta.1';

  static UxTrackerPlatform get _platform => UxTrackerPlatform.instance;

  static Future<void> initialize(UxTrackerConfig config) => _platform.invoke<void>('initialize', {
        ...config.toMap(),
        'wrapperName': 'uxtracker-flutter',
        'wrapperVersion': version,
      });

  /// Records an action. Names starting with `$` are reserved.
  static Future<void> track(String name, {Map<String, Object?>? properties}) =>
      _platform.invoke<void>('track', {'name': name, 'properties': encodeProperties(properties)});

  /// Records a screen view as `$screen` with `$screen_name`.
  static Future<void> screen(String name, {Map<String, Object?>? properties}) =>
      _platform.invoke<void>('screen', {'name': name, 'properties': encodeProperties(properties)});

  /// Links this device to your app's user id (never an email or phone number) and sets profile traits.
  static Future<void> identify(String userId, {Map<String, Object?>? traits}) =>
      _platform.invoke<void>('identify', {'userId': userId, 'traits': encodeProperties(traits)});

  /// Puts the user in a group (company, team, clinic…); later events carry the membership.
  static Future<void> group(String groupType, String groupKey, {Map<String, Object?>? traits}) =>
      _platform.invoke<void>('group', {'groupType': groupType, 'groupKey': groupKey, 'traits': encodeProperties(traits)});

  static Future<void> unsetGroup(String groupType) => _platform.invoke<void>('unsetGroup', {'groupType': groupType});

  /// Super properties: added to every later event's properties, and kept across launches.
  static Future<void> register(Map<String, Object?> properties) =>
      _platform.invoke<void>('register', {'properties': encodeProperties(properties)});

  static Future<void> unregister(String key) => _platform.invoke<void>('unregister', {'key': key});

  /// Call on logout: new anonymous id and session, super properties and groups cleared.
  static Future<void> reset() => _platform.invoke<void>('reset');

  /// Sends queued events now. Completes once they have been attempted.
  static Future<void> flush() => _platform.invoke<void>('flush');

  /// Stops all tracking and deletes queued events. Remembered across launches.
  static Future<void> optOut() => _platform.invoke<void>('optOut');

  static Future<void> optIn() => _platform.invoke<void>('optIn');

  static Future<bool> isOptedOut() async => await _platform.invoke<bool>('isOptedOut') ?? false;

  /// The current distinct id: the user id after [identify], otherwise the anonymous id.
  static Future<String?> distinctId() => _platform.invoke<String>('distinctId');
}
