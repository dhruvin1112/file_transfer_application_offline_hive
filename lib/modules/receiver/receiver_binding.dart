import 'package:get/get.dart';
import '../../core/services/connection_service.dart';
import '../../core/services/qr_service.dart';
import '../../data/repositories/device_repository.dart';
import 'receiver_controller.dart';

class ReceiverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiverController>(
      () => ReceiverController(
        deviceRepository: Get.find<DeviceRepository>(),
        connectionService: Get.find<ConnectionService>(),
        qrService: Get.find<QrService>(),
      ),
    );
  }
}
