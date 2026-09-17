import 'package:flutter/foundation.dart';

/// Converts Dart values to what the platform channel can carry: strings, numbers, booleans, null, lists and
/// string-keyed maps. `DateTime` and `Uri` become strings, enums their name. Anything else is dropped with a
/// debug log. The native SDKs apply the protocol's remaining rules (§4.3).
Map<String, Object?>? encodeProperties(Map<String, Object?>? values) {
  if (values == null) return null;
  final result = <String, Object?>{};
  values.forEach((key, value) {
    final encoded = _encode(value, key);
    if (!identical(encoded, _drop)) result[key] = encoded;
  });
  return result;
}

const Object _drop = Object();

Object? _encode(Object? value, String path) {
  if (value == null || value is String || value is bool || value is int) return value;
  if (value is double) {
    if (value.isFinite) return value;
    debugPrint('UxTracker: $path dropped: NaN and infinity can\'t be sent');
    return _drop;
  }
  if (value is DateTime) return value.toUtc().toIso8601String();
  if (value is Uri) return value.toString();
  if (value is Enum) return value.name;
  if (value is Map) {
    final map = <String, Object?>{};
    value.forEach((key, child) {
      if (key is! String) {
        debugPrint('UxTracker: a non-string key in $path was dropped');
        return;
      }
      final encoded = _encode(child, '$path.$key');
      if (!identical(encoded, _drop)) map[key] = encoded;
    });
    return map;
  }
  if (value is Iterable) {
    var index = 0;
    return [
      for (final child in value)
        if (_encode(child, '$path[${index++}]') case final encoded when !identical(encoded, _drop)) encoded,
    ];
  }
  debugPrint('UxTracker: $path dropped: ${value.runtimeType} can\'t be sent; use strings, numbers, booleans, maps or lists');
  return _drop;
}
