import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uxtracker_flutter_sdk/uxtracker_flutter_sdk.dart';

/// Runs on a simulator or emulator against a real backend:
///   flutter test integration_test --dart-define=UXTRACKER_WRITE_KEY=… --dart-define=UXTRACKER_SERVER_URL=…
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const writeKey = String.fromEnvironment('UXTRACKER_WRITE_KEY');
  const serverUrl = String.fromEnvironment('UXTRACKER_SERVER_URL');

  testWidgets('sends every call through the native SDK', (tester) async {
    await UxTracker.track('Called before initialize', properties: {'buffered': true});
    await UxTracker.initialize(const UxTrackerConfig(writeKey: writeKey, serverUrl: serverUrl, debug: true));

    final anonymousId = await UxTracker.distinctId();
    expect(anonymousId, isNotNull);

    await UxTracker.register({'app_theme': 'dark'});
    await UxTracker.track('Menu day selected', properties: {
      'day': 'monday',
      'menu_id': 1234,
      'price': 99.5,
      'vip': true,
      'tags': ['vegan'],
      'when': DateTime.utc(2026, 9, 16),
    });
    await UxTracker.screen('Dashboard');
    await UxTracker.identify('flutter_e2e_user', traits: {'plan': 'premium'});
    await UxTracker.group('clinic', 'clinic_417', traits: {'name': 'Clínica Centro'});
    await UxTracker.track('Plan day selected', properties: {'day': 3});

    expect(await UxTracker.distinctId(), 'flutter_e2e_user');
    expect(await UxTracker.isOptedOut(), isFalse);

    await UxTracker.flush();
    // ignore: avoid_print
    print('E2E anonymous_id=$anonymousId');
  });
}
