// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing


import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uxtracker_flutter_sdk/models/uxtracker_setup_model.dart';

import 'package:uxtracker_flutter_sdk/uxtracker_flutter_sdk.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getPlatformVersion test', (WidgetTester tester) async {

    final setup = UxTrackerSetup(batchSize: 5, flushInterval: 10);
    await UxtrackerFlutterSdk.initialize(apiKey: 'test_api_key', setup: setup);
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    //expect(version?.isNotEmpty, true);
  });
}
