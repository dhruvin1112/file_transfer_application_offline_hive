import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../data/models/device_model.dart';
import '../constants/app_constants.dart';

class DeviceDiscoveryService {
  RawDatagramSocket? _discoverySocket;
  final StreamController<DeviceModel> _discoveredDevicesController =
      StreamController<DeviceModel>.broadcast();

  Stream<DeviceModel> get onDeviceDiscovered =>
      _discoveredDevicesController.stream;

  final Map<String, DeviceModel> _discoveredDevices = {};
  List<DeviceModel> get discoveredDevices => _discoveredDevices.values.toList();

  bool _isDiscovering = false;
  bool get isDiscovering => _isDiscovering;

  /// Starts listening for UDP broadcast packets from nearby peers on the local Wi-Fi subnet
  Future<void> startDiscovery({int port = AppConstants.defaultDiscoveryPort}) async {
    if (_isDiscovering) return;
    try {
      _discoveredDevices.clear();
      _discoverySocket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        port,
        reuseAddress: true,
      );
      _discoverySocket?.broadcastEnabled = true;
      _isDiscovering = true;

      _discoverySocket?.listen((event) {
        if (event == RawSocketEvent.read) {
          final datagram = _discoverySocket?.receive();
          if (datagram != null) {
            _handleDiscoveryDatagram(datagram);
          }
        }
      });
    } catch (_) {
      _isDiscovering = false;
    }
  }

  /// Broadcasts local device beacon to peers on local network
  Future<void> broadcastPresence({
    required DeviceModel localDevice,
    int port = AppConstants.defaultDiscoveryPort,
  }) async {
    try {
      final broadcastSocket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        0,
      );
      broadcastSocket.broadcastEnabled = true;

      final message = jsonEncode({
        'type': 'DISCOVERY_BEACON',
        'device': localDevice.toMap(),
      });

      final data = utf8.encode(message);
      broadcastSocket.send(
        data,
        InternetAddress('255.255.255.255'),
        port,
      );

      broadcastSocket.close();
    } catch (_) {
      // Ignored if network broadcast is blocked by router AP isolation
    }
  }

  void _handleDiscoveryDatagram(Datagram datagram) {
    try {
      final message = utf8.decode(datagram.data);
      final map = jsonDecode(message) as Map<String, dynamic>;
      if (map['type'] == 'DISCOVERY_BEACON' && map['device'] != null) {
        final device =
            DeviceModel.fromMap(map['device'] as Map<String, dynamic>);
        // Update connectionAddress to actual sender IP if necessary
        final updatedDevice = device.copyWith(
          connectionAddress: datagram.address.address,
        );
        _discoveredDevices[updatedDevice.id] = updatedDevice;
        _discoveredDevicesController.add(updatedDevice);
      }
    } catch (_) {
      // Malformed datagram
    }
  }

  /// Stops discovery socket
  void stopDiscovery() {
    _discoverySocket?.close();
    _discoverySocket = null;
    _isDiscovering = false;
  }

  void dispose() {
    stopDiscovery();
    _discoveredDevicesController.close();
  }
}
