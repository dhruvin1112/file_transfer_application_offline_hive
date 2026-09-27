import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';

class LocalNetworkService {
  final NetworkInfo _networkInfo = NetworkInfo();

  /// Retrieves the active local Wi-Fi / Hotspot IPv4 address
  Future<String?> getLocalIpAddress() async {
    try {
      // First attempt using network_info_plus
      final wifiIp = await _networkInfo.getWifiIP();
      if (wifiIp != null && wifiIp.isNotEmpty && wifiIp != '0.0.0.0') {
        return wifiIp;
      }
    } catch (_) {
      // Fallback to dart:io NetworkInterface enumeration
    }

    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLinkLocal: false,
      );

      for (final interface in interfaces) {
        for (final addr in interface.addresses) {
          if (!addr.isLoopback && addr.type == InternetAddressType.IPv4) {
            return addr.address;
          }
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  /// Retrieves the Wi-Fi network name (SSID) if accessible
  Future<String?> getWifiName() async {
    try {
      return await _networkInfo.getWifiName();
    } catch (_) {
      return null;
    }
  }

  /// Verifies if device has an active non-loopback local network interface
  Future<bool> isConnectedToLocalNetwork() async {
    final ip = await getLocalIpAddress();
    return ip != null && ip.isNotEmpty;
  }
}
