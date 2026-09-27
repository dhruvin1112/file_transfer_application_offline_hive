import Foundation
import Flutter
import UIKit

class NativeChannelManager {
    static let channelName = "com.example.file_transfer_appplication/native_channel"

    private let deviceService: IOSDeviceService
    private let connectivityService: IOSConnectivityService

    init(deviceService: IOSDeviceService, connectivityService: IOSConnectivityService) {
        self.deviceService = deviceService
        self.connectivityService = connectivityService
    }

    static func register(with messenger: FlutterBinaryMessenger) -> NativeChannelManager {
        let deviceService = IOSDeviceService()
        let connectivityService = IOSConnectivityService()
        let manager = NativeChannelManager(deviceService: deviceService, connectivityService: connectivityService)

        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            manager.handle(call, result: result)
        }
        return manager
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getNativeDeviceInfo":
            let info = deviceService.getDeviceInfo()
            result(info)
        case "getWifiIpAddress":
            let ip = connectivityService.getWifiIpAddress()
            result(ip)
        case "isWifiConnected":
            // If Wi-Fi IP is present on en0, Wi-Fi is active
            let isConnected = connectivityService.getWifiIpAddress() != nil
            result(isConnected)
        case "openWifiSettings", "openAppSettings":
            let opened = connectivityService.openSettings()
            result(opened)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
