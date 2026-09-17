package com.wzagroup.uxtracker.flutter

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.wzagroup.uxtracker.UxTracker
import com.wzagroup.uxtracker.UxTrackerConfig
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * Bridges Dart calls to the native UxTracker Android SDK. It keeps no queue or state of its own (§10.6), and
 * every call replies exactly once, including on error.
 */
class UxTrackerFlutterPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.wzagroup.uxtracker/flutter")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                "initialize" -> {
                    UxTracker.setWrapper(call.string("wrapperName"), call.string("wrapperVersion"))
                    val config = UxTrackerConfig.Builder(call.string("writeKey"), call.string("serverUrl"))
                        .flushIntervalSeconds(call.int("flushIntervalSeconds").toLong())
                        .flushAt(call.int("flushAt"))
                        .maxQueueSize(call.int("maxQueueSize"))
                        .sessionTimeoutSeconds(call.int("sessionTimeoutSeconds").toLong())
                        .trackAppLifecycle(call.argument<Boolean>("trackAppLifecycle") ?: true)
                        .optOutByDefault(call.argument<Boolean>("optOutByDefault") ?: false)
                        .debug(call.argument<Boolean>("debug") ?: false)
                        .build()
                    UxTracker.initialize(context, config)
                    result.success(null)
                }
                "track" -> reply(result) { UxTracker.track(call.string("name"), call.map("properties")) }
                "screen" -> reply(result) { UxTracker.screen(call.string("name"), call.map("properties")) }
                "identify" -> reply(result) { UxTracker.identify(call.string("userId"), call.map("traits")) }
                "group" -> reply(result) { UxTracker.group(call.string("groupType"), call.string("groupKey"), call.map("traits")) }
                "unsetGroup" -> reply(result) { UxTracker.unsetGroup(call.string("groupType")) }
                "register" -> reply(result) { UxTracker.register(call.map("properties") ?: emptyMap()) }
                "unregister" -> reply(result) { UxTracker.unregister(call.string("key")) }
                "reset" -> reply(result) { UxTracker.reset() }
                "optOut" -> reply(result) { UxTracker.optOut() }
                "optIn" -> reply(result) { UxTracker.optIn() }
                "isOptedOut" -> result.success(UxTracker.isOptedOut())
                "distinctId" -> result.success(UxTracker.distinctId())
                // The native callback runs on a background thread; Flutter replies must be sent on the main thread.
                "flush" -> UxTracker.flush { mainHandler.post { result.success(null) } }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("uxtracker_error", e.message, null)
        }
    }

    private inline fun reply(result: Result, action: () -> Unit) {
        action()
        result.success(null)
    }

    private fun MethodCall.string(key: String): String =
        argument<String>(key) ?: throw IllegalArgumentException("Missing argument '$key'")

    private fun MethodCall.int(key: String): Int =
        argument<Number>(key)?.toInt() ?: throw IllegalArgumentException("Missing argument '$key'")

    @Suppress("UNCHECKED_CAST")
    private fun MethodCall.map(key: String): Map<String, Any?>? = argument<Map<String, Any?>>(key)
}
