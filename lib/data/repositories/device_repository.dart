import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/device_discovery_service.dart';
import '../../core/services/local_network_service.dart';
import '../../core/services/native_channel_service.dart';
import '../../core/services/shared_preferences_service.dart';
import '../models/device_model.dart';

class DeviceRepository {
  final DeviceDiscoveryService discoveryService;
  final LocalNetworkService networkService;
  final NativeChannelService nativeChannelService;
  final SharedPreferencesService prefsService;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  DeviceRepository({
    required this.discoveryService,
    required this.networkService,
    required this.nativeChannelService,
    required this.prefsService,
  });

  /// Builds the current device representation
  Future<DeviceModel> getLocalDevice() async {
    final customName = prefsService.deviceCustomName;
    String name = customName ?? '';
    String platform = Platform.isAndroid ? 'Android' : (Platform.isIOS ? 'iOS' : 'Desktop');
    String id = 'device_${Platform.operatingSystem}';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        if (name.isEmpty) {
          name = '${androidInfo.brand.toUpperCase()} ${androidInfo.model}';
        }
        id = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        if (name.isEmpty) {
          name = iosInfo.name;
        }
        id = iosInfo.identifierForVendor ?? 'ios_device';
      }
    } catch (_) {
      if (name.isEmpty) name = '$platform Device';
    }

    final ip = await networkService.getLocalIpAddress() ?? '0.0.0.0';

    return DeviceModel(
      id: id,
      deviceName: name,
      platform: platform,
      connectionAddress: ip,
      port: AppConstants.defaultTransferPort,
      isConnected: false,
    );
  }

  Stream<DeviceModel> get onDeviceDiscovered => discoveryService.onDeviceDiscovered;

  List<DeviceModel> get discoveredDevices => discoveryService.discoveredDevices;

  Future<void> startDiscovery() => discoveryService.startDiscovery();

  Future<void> stopDiscovery() async => discoveryService.stopDiscovery();

  Future<void> broadcastPresence(DeviceModel localDevice) =>
      discoveryService.broadcastPresence(localDevice: localDevice);

  Future<Map<String, dynamic>?> getHardwareMetrics() =>
      nativeChannelService.getNativeDeviceInfo();
}
