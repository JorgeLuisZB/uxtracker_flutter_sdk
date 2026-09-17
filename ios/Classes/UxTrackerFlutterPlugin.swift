import Flutter
import UIKit
import UxTrackerSDK

/// Bridges Dart calls to the native UxTracker iOS SDK. It keeps no queue or state of its own (§10.6), and every
/// call replies exactly once, including on error.
public final class UxTrackerFlutterPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.wzagroup.uxtracker/flutter", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(UxTrackerFlutterPlugin(), channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any] ?? [:]

        func string(_ key: String) -> String? { args[key] as? String }
        func int(_ key: String, _ fallback: Int) -> Int { (args[key] as? NSNumber)?.intValue ?? fallback }
        func bool(_ key: String, _ fallback: Bool) -> Bool { (args[key] as? NSNumber)?.boolValue ?? fallback }
        func map(_ key: String) -> [String: Any]? { args[key] as? [String: Any] }
        func missing(_ key: String) { result(FlutterError(code: "uxtracker_error", message: "Missing argument '\(key)'", details: nil)) }

        switch call.method {
        case "initialize":
            guard let writeKey = string("writeKey") else { return missing("writeKey") }
            guard let serverUrl = string("serverUrl") else { return missing("serverUrl") }
            if let name = string("wrapperName"), let version = string("wrapperVersion") {
                UxTracker.setWrapper(name: name, version: version)
            }
            UxTracker.initialize(config: UxTrackerConfig(
                writeKey: writeKey,
                serverUrl: serverUrl,
                flushIntervalSeconds: int("flushIntervalSeconds", 30),
                flushAt: int("flushAt", 20),
                maxQueueSize: int("maxQueueSize", 10_000),
                sessionTimeoutSeconds: int("sessionTimeoutSeconds", 1_800),
                trackAppLifecycle: bool("trackAppLifecycle", true),
                optOutByDefault: bool("optOutByDefault", false),
                debug: bool("debug", false)))
            result(nil)
        case "track":
            guard let name = string("name") else { return missing("name") }
            UxTracker.track(name, properties: map("properties"))
            result(nil)
        case "screen":
            guard let name = string("name") else { return missing("name") }
            UxTracker.screen(name, properties: map("properties"))
            result(nil)
        case "identify":
            guard let userId = string("userId") else { return missing("userId") }
            UxTracker.identify(userId, traits: map("traits"))
            result(nil)
        case "group":
            guard let groupType = string("groupType") else { return missing("groupType") }
            guard let groupKey = string("groupKey") else { return missing("groupKey") }
            UxTracker.group(groupType, key: groupKey, traits: map("traits"))
            result(nil)
        case "unsetGroup":
            guard let groupType = string("groupType") else { return missing("groupType") }
            UxTracker.unsetGroup(groupType)
            result(nil)
        case "register":
            UxTracker.register(map("properties") ?? [:])
            result(nil)
        case "unregister":
            guard let key = string("key") else { return missing("key") }
            UxTracker.unregister(key)
            result(nil)
        case "reset":
            UxTracker.reset()
            result(nil)
        case "optOut":
            UxTracker.optOut()
            result(nil)
        case "optIn":
            UxTracker.optIn()
            result(nil)
        case "isOptedOut":
            result(UxTracker.isOptedOut)
        case "distinctId":
            result(UxTracker.distinctId)
        case "flush":
            // The native completion runs on a background queue; Flutter replies must be sent on the main thread.
            UxTracker.flush { DispatchQueue.main.async { result(nil) } }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
