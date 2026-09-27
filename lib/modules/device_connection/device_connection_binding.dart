import 'package:get/get.dart';
import '../../data/repositories/device_repository.dart';
import 'device_connection_controller.dart';

class DeviceConnectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeviceConnectionController>(
      () => DeviceConnectionController(
        deviceRepository: Get.find<DeviceRepository>(),
      ),
    );
  }
}
