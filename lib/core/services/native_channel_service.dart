import 'package:flutter/services.dart';
import '../constants/method_channel_constants.dart';

class NativeChannelService {
  final MethodChannel _channel =
      const MethodChannel(MethodChannelConstants.channelName);

  /// Queries platform-specific device specifications and battery stats
  Future<Map<String, dynamic>?> getNativeDeviceInfo() async {
    try {
      final result =
          await _channel.invokeMapMethod<String, dynamic>(
              MethodChannelConstants.getNativeDeviceInfo);
      return result;
    } catch (_) {
      return null;
    }
  }

  /// Retrieves local Wi-Fi IP address via platform native network interfaces
  Future<String?> getWifiIpAddress() async {
    try {
      return await _channel.invokeMethod<String>(
          MethodChannelConstants.getWifiIpAddress);
    } catch (_) {
      return null;
    }
  }

  /// Checks if device is actively connected to Wi-Fi via native connectivity manager
  Future<bool> isWifiConnected() async {
    try {
      final result = await _channel.invokeMethod<bool>(
          MethodChannelConstants.isWifiConnected);
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Launches the native system Wi-Fi settings page
  Future<bool> openWifiSettings() async {
    try {
      final result = await _channel.invokeMethod<bool>(
          MethodChannelConstants.openWifiSettings);
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Launches the native system application settings page
  Future<bool> openAppSettings() async {
    try {
      final result = await _channel.invokeMethod<bool>(
          MethodChannelConstants.openAppSettings);
      return result ?? false;
    } catch (_) {
      return false;
    }
  }
}
