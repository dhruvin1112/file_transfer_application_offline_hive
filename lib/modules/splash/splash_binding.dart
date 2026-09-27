import 'package:get/get.dart';
import '../../core/services/local_storage_service.dart';
import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(
        storageService: Get.find<LocalStorageService>(),
      ),
    );
  }
}
