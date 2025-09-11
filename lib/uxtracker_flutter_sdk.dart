
import 'models/uxtracker_setup_model.dart';
import 'uxtracker_flutter_sdk_platform_interface.dart';

class UxtrackerFlutterSdk {

  static Future<void> initialize({required String apiKey, required UxTrackerSetup? setup}) {
    return UxtrackerFlutterSdkPlatform.instance.initialize(apiKey: apiKey, setup: setup);
  }

  static Future<void> track({required String event, Map<String, String>? properties}) {
    return UxtrackerFlutterSdkPlatform.instance.track(event: event, properties: properties);
  }

  static Future<void> identify({required String userId}) {
    return UxtrackerFlutterSdkPlatform.instance.identify(userId: userId);
  }
}
