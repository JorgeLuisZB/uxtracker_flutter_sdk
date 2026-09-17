import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:uxtracker_flutter_sdk/src/method_channel.dart';
import 'package:uxtracker_flutter_sdk/src/platform_interface.dart';
import 'package:uxtracker_flutter_sdk/uxtracker_flutter_sdk.dart';

class _RecordingPlatform extends UxTrackerPlatform with MockPlatformInterfaceMixin {
  final calls = <MethodCall>[];
  Object? reply;

  @override
  Future<T?> invoke<T>(String method, [Map<String, Object?>? arguments]) async {
    calls.add(MethodCall(method, arguments));
    return reply as T?;
  }
}

enum Plan { premium }

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UxTracker', () {
    late _RecordingPlatform platform;

    setUp(() {
      platform = _RecordingPlatform();
      UxTrackerPlatform.instance = platform;
    });

    test('initialize sends the config and identifies the wrapper', () async {
      await UxTracker.initialize(const UxTrackerConfig(writeKey: 'uxt_pk_test_mx_k', serverUrl: 'https://i.test', flushAt: 5, debug: true));

      final call = platform.calls.single;
      expect(call.method, 'initialize');
      expect(call.arguments, containsPair('writeKey', 'uxt_pk_test_mx_k'));
      expect(call.arguments, containsPair('flushAt', 5));
      expect(call.arguments, containsPair('debug', true));
      expect(call.arguments, containsPair('wrapperName', 'uxtracker-flutter'));
      expect(call.arguments, containsPair('wrapperVersion', UxTracker.version));
    });

    test('every API method maps to its native call', () async {
      await UxTracker.track('Menu day selected', properties: {'day': 'monday'});
      await UxTracker.screen('Dashboard');
      await UxTracker.identify('user_1', traits: {'plan': 'premium'});
      await UxTracker.group('clinic', 'clinic_417', traits: {'name': 'Centro'});
      await UxTracker.unsetGroup('clinic');
      await UxTracker.register({'theme': 'dark'});
      await UxTracker.unregister('theme');
      await UxTracker.reset();
      await UxTracker.flush();
      await UxTracker.optOut();
      await UxTracker.optIn();

      expect(platform.calls.map((c) => c.method), [
        'track', 'screen', 'identify', 'group', 'unsetGroup', 'register', 'unregister', 'reset', 'flush', 'optOut', 'optIn',
      ]);
      expect(platform.calls[0].arguments, {'name': 'Menu day selected', 'properties': {'day': 'monday'}});
      expect(platform.calls[2].arguments, {'userId': 'user_1', 'traits': {'plan': 'premium'}});
      expect(platform.calls[3].arguments, {'groupType': 'clinic', 'groupKey': 'clinic_417', 'traits': {'name': 'Centro'}});
    });

    test('values the channel can\'t carry are converted or dropped', () async {
      await UxTracker.track('Converted', properties: {
        'when': DateTime.utc(2026, 9, 16, 18, 3, 58),
        'link': Uri.parse('https://x.test/a'),
        'plan': Plan.premium,
        'tags': {'vegan', 'keto'},
        'nested': {1: 'dropped key', 'ok': double.nan, 'fine': 1.5},
        'nan': double.infinity,
        'object': Object(),
        'none': null,
      });

      final properties = (platform.calls.single.arguments as Map)['properties'] as Map;
      expect(properties['when'], '2026-09-16T18:03:58.000Z');
      expect(properties['link'], 'https://x.test/a');
      expect(properties['plan'], 'premium');
      expect(properties['tags'], ['vegan', 'keto']);
      expect(properties['nested'], {'fine': 1.5});
      expect(properties.containsKey('nan'), isFalse);
      expect(properties.containsKey('object'), isFalse);
      expect(properties.containsKey('none'), isTrue);
    });

    test('queries return native values with safe defaults', () async {
      expect(await UxTracker.isOptedOut(), isFalse);
      platform.reply = 'user_1';
      expect(await UxTracker.distinctId(), 'user_1');
    });
  });

  group('MethodChannelUxTracker', () {
    final channelPlatform = MethodChannelUxTracker();

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channelPlatform.channel, null);
    });

    test('never throws when the native side fails or is missing', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channelPlatform.channel, (call) async {
        throw PlatformException(code: 'boom');
      });
      UxTrackerPlatform.instance = channelPlatform;
      await expectLater(UxTracker.track('x'), completes);
      expect(await UxTracker.isOptedOut(), isFalse);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channelPlatform.channel, null);
      await expectLater(UxTracker.flush(), completes);
    });
  });
}
