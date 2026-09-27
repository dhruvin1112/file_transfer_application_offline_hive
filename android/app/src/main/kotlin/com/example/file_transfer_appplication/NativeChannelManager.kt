package com.example.file_transfer_appplication

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class NativeChannelManager(
    private val context: Context,
    private val deviceService: AndroidDeviceService,
    private val connectivityService: AndroidConnectivityService
) : MethodChannel.MethodCallHandler {

    companion object {
        private const val CHANNEL_NAME = "com.example.file_transfer_appplication/native_channel"

        fun registerWith(flutterEngine: FlutterEngine, context: Context): NativeChannelManager {
            val deviceService = AndroidDeviceService(context)
            val connectivityService = AndroidConnectivityService(context)
            val manager = NativeChannelManager(context, deviceService, connectivityService)

            val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            channel.setMethodCallHandler(manager)
            return manager
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getNativeDeviceInfo" -> {
                try {
                    val info = deviceService.getDeviceInfo()
                    result.success(info)
                } catch (e: Exception) {
                    result.error("DEVICE_INFO_ERROR", e.localizedMessage, null)
                }
            }
            "getWifiIpAddress" -> {
                try {
                    val ip = connectivityService.getWifiIpAddress()
                    result.success(ip)
                } catch (e: Exception) {
                    result.error("IP_ERROR", e.localizedMessage, null)
                }
            }
            "isWifiConnected" -> {
                try {
                    result.success(connectivityService.isWifiConnected())
                } catch (e: Exception) {
                    result.error("WIFI_STATUS_ERROR", e.localizedMessage, null)
                }
            }
            "openWifiSettings" -> {
                val opened = connectivityService.openWifiSettings()
                result.success(opened)
            }
            "openAppSettings" -> {
                val opened = connectivityService.openAppSettings()
                result.success(opened)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
