package com.wzagroup.uxtrackersdkflutter.uxtracker_flutter_sdk

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.wzagroup.uxtracker_android_sdk.UXTracker
import com.wzagroup.uxtracker_android_sdk.models.UXTrackerSetup

/** UxtrackerFlutterSdkPlugin */
class UxtrackerFlutterSdkPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "uxtracker_flutter_sdk")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "initialize" -> {
                val args = call.arguments as Map<*, *>
                val apiKey = args["apiKey"] as String

                val setupMap = args["setup"] as? Map<*, *>
                val flushInterval = (setupMap?.get("flushInterval") as? Long) ?: 40
                val batchSize = (setupMap?.get("batchSize") as? Int) ?: 20
                val setup = UXTrackerSetup(flushInterval, batchSize)

                UXTracker.shared().initialize(context, apiKey = apiKey, setup = setup)
                result.success(null)
            }

            "track" -> {
                val args = call.arguments as Map<*, *>
                val event = args["event"] as String
                val properties = args["properties"] as? Map<String, Any> ?: emptyMap()

                UXTracker.shared().track(event, properties)
                result.success(null)
            }

            "identify" -> {
                val args = call.arguments as Map<*, *>
                val userId = args["userId"] as String

                UXTracker.shared().identify(userId)
                result.success(null)
            }

            "reset" -> {
                UXTracker.shared().reset()
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
