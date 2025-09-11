import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'models/uxtracker_setup_model.dart';
import 'uxtracker_flutter_sdk_platform_interface.dart';

/// An implementation of [UxtrackerFlutterSdkPlatform] that uses method channels.
class MethodChannelUxtrackerFlutterSdk extends UxtrackerFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('uxtracker_flutter_sdk');

  @override
  Future<void> initialize({required String apiKey, UxTrackerSetup? setup = const UxTrackerSetup()}) async {
    await methodChannel.invokeMethod('initialize', {
      'apiKey': apiKey,
      'setup': setup?.toMap()
    });
  }

  @override
  Future<void> track({required String event, Map<String, String>? properties}) async {
    await methodChannel.invokeMethod('track', {
      'event': event,
      'properties': properties ?? {},
    });
  }

  @override
  Future<void> identify({required String userId}) async {
    await methodChannel.invokeMethod('identify', {
      'userId': userId
    });
  }
}
