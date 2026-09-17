import 'package:flutter/material.dart';
import 'package:uxtracker_flutter_sdk/uxtracker_flutter_sdk.dart';

/// Run against a backend with, for example:
///   flutter run --dart-define=UXTRACKER_WRITE_KEY=uxt_pk_test_mx_… --dart-define=UXTRACKER_SERVER_URL=http://localhost:7002
/// (Android emulator: http://10.0.2.2:7002)
const writeKey = String.fromEnvironment('UXTRACKER_WRITE_KEY', defaultValue: 'uxt_pk_test_mx_replace_me');
const serverUrl = String.fromEnvironment('UXTRACKER_SERVER_URL', defaultValue: 'http://localhost:7002');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UxTracker.initialize(const UxTrackerConfig(writeKey: writeKey, serverUrl: serverUrl, debug: true));
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  String? _distinctId;

  @override
  void initState() {
    super.initState();
    UxTracker.screen('Example home');
    _refresh();
  }

  Future<void> _refresh() async {
    final id = await UxTracker.distinctId();
    if (mounted) setState(() => _distinctId = id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('UxTracker example')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('distinct_id: ${_distinctId ?? '…'}', key: const Key('distinctId')),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('track'),
              onPressed: () => UxTracker.track('Button tapped', properties: {'button': 'track', 'at': DateTime.now()}),
              child: const Text('Track event'),
            ),
            FilledButton(
              key: const Key('identify'),
              onPressed: () async {
                await UxTracker.identify('example_user', traits: {'plan': 'premium'});
                await _refresh();
              },
              child: const Text('Identify'),
            ),
            FilledButton(
              key: const Key('reset'),
              onPressed: () async {
                await UxTracker.reset();
                await _refresh();
              },
              child: const Text('Reset'),
            ),
            FilledButton(
              key: const Key('flush'),
              onPressed: UxTracker.flush,
              child: const Text('Flush'),
            ),
          ],
        ),
      ),
    );
  }
}
