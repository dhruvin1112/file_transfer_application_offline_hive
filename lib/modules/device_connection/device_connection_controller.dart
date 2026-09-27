import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/device_model.dart';
import '../../data/models/file_model.dart';
import '../../data/repositories/device_repository.dart';

class DeviceConnectionController extends GetxController {
  final DeviceRepository deviceRepository;

  DeviceConnectionController({required this.deviceRepository});

  final RxList<DeviceModel> nearbyDevices = <DeviceModel>[].obs;
  final RxBool isScanning = false.obs;
  List<FileModel> pendingFiles = [];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['files'] != null) {
      pendingFiles = List<FileModel>.from(args['files'] as List);
    }
    _startDiscovery();
  }

  void _startDiscovery() {
    isScanning.value = true;
    deviceRepository.startDiscovery();
    deviceRepository.onDeviceDiscovered.listen((device) {
      if (!nearbyDevices.any((d) => d.id == device.id)) {
        nearbyDevices.add(device);
      }
    });
  }

  void openQrScanner() {
    Get.toNamed(
      AppRoutes.qr,
      arguments: {'files': pendingFiles},
    );
  }

  void selectDevice(DeviceModel device) {
    Get.toNamed(
      AppRoutes.transfer,
      arguments: {
        'targetDevice': device,
        'files': pendingFiles,
        'isSender': true,
      },
    );
  }

  @override
  void onClose() {
    deviceRepository.stopDiscovery();
    super.onClose();
  }
}
