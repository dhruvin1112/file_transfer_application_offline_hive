import 'package:get/get.dart';
import '../../core/services/connection_service.dart';
import '../../core/services/qr_service.dart';
import 'qr_controller.dart';

class QrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrController>(
      () => QrController(
        qrService: Get.find<QrService>(),
        connectionService: Get.find<ConnectionService>(),
      ),
    );
  }
}
