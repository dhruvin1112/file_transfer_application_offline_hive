import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/services/local_storage_service.dart';

class SplashController extends GetxController {
  final LocalStorageService storageService;

  SplashController({required this.storageService});

  final RxBool isLoading = true.obs;

  @override
  void onReady() {
    super.onReady();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    isLoading.value = false;

    if (storageService.isOnboardingCompleted) {
      Get.offNamed(AppRoutes.home);
    } else {
      Get.offNamed(AppRoutes.onboarding);
    }
  }
}
