import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/services/local_storage_service.dart';

class OnboardingController extends GetxController {
  final LocalStorageService storageService;

  OnboardingController({required this.storageService});

  final RxInt currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> completeOnboarding() async {
    await storageService.setOnboardingCompleted(true);
    Get.offNamed(AppRoutes.home);
  }
}
