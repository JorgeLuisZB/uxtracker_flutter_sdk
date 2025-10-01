
import 'models/uxtracker_setup_model.dart';
import 'uxtracker_flutter_sdk_platform_interface.dart';

class UxtrackerFlutterSdk {

  static Future<void> initialize({required String apiKey, required UxTrackerSetup? setup}) {
    return UxtrackerFlutterSdkPlatform.instance.initialize(apiKey: apiKey, setup: setup);
  }

  static Future<void> track(String event, {Map<String, dynamic>? properties}) {
    return UxtrackerFlutterSdkPlatform.instance.track(event, properties: properties);
  }

  static Future<void> identify({required String userId}) {
    return UxtrackerFlutterSdkPlatform.instance.identify(userId: userId);
  }

  static Future<void> reset() {
    return UxtrackerFlutterSdkPlatform.instance.reset();
  }
}
