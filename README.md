# uxtracker_flutter_sdk

UxTracker product analytics for Flutter. A thin wrapper over the native
[Android](https://github.com/JorgeLuisZB/uxtracker-android-sdk) and [iOS](https://github.com/JorgeLuisZB/uxtracker-ios-sdk)
SDKs: queueing, persistence, retries, sessions, identity and lifecycle events all run natively, so Flutter
apps behave exactly like native ones (ingestion protocol §10.6).

- **Android** 21+ · **iOS** 13+

## Install

```yaml
dependencies:
  uxtracker_flutter_sdk:
    git:
      url: https://github.com/JorgeLuisZB/uxtracker_flutter_sdk.git
      ref: 1.0.0-beta.1
```

The Android SDK comes from JitPack (the plugin adds the repository). On iOS the plugin depends on the
`UxTrackerSDK` pod; until it is published, point to it in `ios/Podfile`, inside `target 'Runner'`:

```ruby
pod 'UxTrackerSDK', :git => 'https://github.com/JorgeLuisZB/uxtracker-ios-sdk.git', :tag => '1.0.0-beta.1'
```

## Use

```dart
import 'package:uxtracker_flutter_sdk/uxtracker_flutter_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UxTracker.initialize(const UxTrackerConfig(
    writeKey: 'uxt_pk_live_mx_…',                // project write key
    serverUrl: 'https://ingest.mx.example.com',   // your project's region
  ));
  runApp(const App());
}

UxTracker.track('Menu day selected', properties: {'day': 'monday', 'menu_id': 1234});
UxTracker.screen('Dashboard');

UxTracker.identify('user_98231', traits: {'plan': 'premium'});   // on login; never an email or phone
UxTracker.group('clinic', 'clinic_417', traits: {'name': 'Clínica Centro'});
UxTracker.register({'app_theme': 'dark'});                      // added to every later event

UxTracker.reset();                                              // on logout
UxTracker.optOut(); UxTracker.optIn();                          // user consent
await UxTracker.flush();                                        // send now (normally automatic)
await UxTracker.distinctId();                                   // current user id or anonymous id
```

Calls don't need to be awaited and never throw. `DateTime` values are sent as ISO 8601 UTC strings, `Uri` as
strings and enums by name; other objects are dropped with a debug log.

`UxTrackerConfig` accepts the same options as the native SDKs: `flushIntervalSeconds`, `flushAt`,
`maxQueueSize`, `sessionTimeoutSeconds`, `trackAppLifecycle`, `optOutByDefault` and `debug`.

## Local development against unpublished native SDKs

- **Android:** publish the native SDK to Maven local
  (`./gradlew :uxtracker:publishReleasePublicationToMavenLocal` in `uxtracker-android-sdk`) and add
  `uxtracker.localSdk=true` to the app's `android/gradle.properties`.
- **iOS:** `pod 'UxTrackerSDK', :path => '/path/to/uxtracker-sdk-ios'` in `ios/Podfile`.
- **Plain `http://` backends** need `debug: true`, plus `android:usesCleartextTraffic="true"` in a debug
  manifest and `NSAllowsLocalNetworking` in `Info.plist`. The example app has all three.

## Tests

```bash
flutter test                                   # Dart API and channel tests

cd example                                     # native SDKs end to end, against a running backend
flutter test integration_test -d <device> \
  --dart-define=UXTRACKER_WRITE_KEY=uxt_pk_test_mx_… \
  --dart-define=UXTRACKER_SERVER_URL=http://localhost:7002   # Android emulator: http://10.0.2.2:7002
```
