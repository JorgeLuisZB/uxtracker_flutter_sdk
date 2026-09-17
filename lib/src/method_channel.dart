import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'platform_interface.dart';

class MethodChannelUxTracker extends UxTrackerPlatform {
  @visibleForTesting
  final MethodChannel channel = const MethodChannel('com.wzagroup.uxtracker/flutter');

  /// Analytics must never break the app (§10.5): platform errors are logged in debug builds and swallowed.
  @override
  Future<T?> invoke<T>(String method, [Map<String, Object?>? arguments]) async {
    try {
      return await channel.invokeMethod<T>(method, arguments);
    } on PlatformException catch (e) {
      debugPrint('UxTracker: $method failed: ${e.code} ${e.message}');
    } on MissingPluginException {
      debugPrint('UxTracker: native plugin not available ($method ignored)');
    }
    return null;
  }
}
