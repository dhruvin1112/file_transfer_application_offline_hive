import 'package:get/get.dart';
import '../../core/services/local_storage_service.dart';
import 'onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(
        storageService: Get.find<LocalStorageService>(),
      ),
    );
  }
}
