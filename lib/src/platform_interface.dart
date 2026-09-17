import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel.dart';

/// Transport between Dart and the native SDKs. Replaceable in tests.
abstract class UxTrackerPlatform extends PlatformInterface {
  UxTrackerPlatform() : super(token: _token);

  static final Object _token = Object();

  static UxTrackerPlatform _instance = MethodChannelUxTracker();

  static UxTrackerPlatform get instance => _instance;

  static set instance(UxTrackerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Invokes a native method. Implementations must not throw.
  Future<T?> invoke<T>(String method, [Map<String, Object?>? arguments]);
}
