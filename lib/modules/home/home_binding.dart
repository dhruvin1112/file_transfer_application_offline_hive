import 'package:get/get.dart';
import '../../core/services/ad_service.dart';
import '../../data/repositories/device_repository.dart';
import '../../data/repositories/history_repository.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        deviceRepository: Get.find<DeviceRepository>(),
        historyRepository: Get.find<HistoryRepository>(),
        adService: Get.find<AdService>(),
      ),
    );
  }
}
