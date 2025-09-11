import Flutter
import UIKit
import UXTrackerSDK

@MainActor
public class UxtrackerFlutterSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "uxtracker_flutter_sdk", binaryMessenger: registrar.messenger())
    let instance = UxtrackerFlutterSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
        guard let args = call.arguments as? [String: Any],
              let apiKey = args["apiKey"] as? String,
              let setupDict = args["setup"] as? [String: Any],
              let flushInterval = setupDict["flushInterval"] as? Double,
              let batchSize = setupDict["batchSize"] as? Int else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for initialize", details: nil))
            return
        }

        let uxTrackerSetup = UXTrackerSetup(flushInterval: flushInterval, batchSize: batchSize)
        UXTracker.shared.initialize(apiKey: apiKey, uxTrackerSetup: uxTrackerSetup)
        print("initialized completed")
        result(nil)
    case "track":
        if let args = call.arguments as? [String: Any],
               let event = args["event"] as? String,
               let properties = args["properties"] as? [String: String] {
                
                UXTracker.shared.track(eventName: event, userProperties: properties)
                
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing or invalid arguments for 'track'", details: nil))
            }
        print("event sent")
        result(nil)
    case "identify":
        if let args = call.arguments as? [String: Any],
           let userId = args["userId"] as? String {
            
            UXTracker.shared.identify(userId: userId)
            
            result(nil)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing or invalid arguments for 'identify'", details: nil))
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
