import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:uxtracker_flutter_sdk/models/uxtracker_setup_model.dart';
import 'package:uxtracker_flutter_sdk/uxtracker_flutter_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      final setup = UxTrackerSetup(batchSize: 5, flushInterval: 10);
      await UxtrackerFlutterSdk.initialize(apiKey: 'api_key_test', setup: setup);
    } on PlatformException {
      rethrow;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                child: Text('track event'),
                onPressed: () async {
                  await UxtrackerFlutterSdk.track(event: 'Button pressed', properties: {'Action': 'Navigation'});
                  },
              ),
              MaterialButton(
                child: Text('Identify'),
                onPressed: () async {
                  await UxtrackerFlutterSdk.identify(userId: 'ce93d891-119a-49c7-a83d-197d68c81150');
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
