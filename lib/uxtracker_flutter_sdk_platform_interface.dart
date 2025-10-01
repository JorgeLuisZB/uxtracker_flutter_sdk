import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'models/uxtracker_setup_model.dart';
import 'uxtracker_flutter_sdk_method_channel.dart';

abstract class UxtrackerFlutterSdkPlatform extends PlatformInterface {
  /// Constructs a UxtrackerFlutterSdkPlatform.
  UxtrackerFlutterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static UxtrackerFlutterSdkPlatform _instance = MethodChannelUxtrackerFlutterSdk();

  /// The default instance of [UxtrackerFlutterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelUxtrackerFlutterSdk].
  static UxtrackerFlutterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UxtrackerFlutterSdkPlatform] when
  /// they register themselves.
  static set instance(UxtrackerFlutterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize({required String apiKey, required UxTrackerSetup? setup}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> track(String event, {Map<String, dynamic>? properties}) {
    throw UnimplementedError('track(String event, {Map<String, dynamic>? properties}) has not been implemented.');
  }

  Future<void> identify({required String userId}) {
    throw UnimplementedError('identify({required String userId}) has not been implemented.');
  }

  Future<void> reset() {
    throw UnimplementedError('reset() has not been implemented.');
  }
}
