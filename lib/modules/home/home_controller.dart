import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../app/routes/app_routes.dart';
import '../../core/services/ad_service.dart';
import '../../data/models/device_model.dart';
import '../../data/repositories/device_repository.dart';
import '../../data/repositories/history_repository.dart';

class HomeController extends GetxController {
  final DeviceRepository deviceRepository;
  final HistoryRepository historyRepository;
  final AdService adService;

  HomeController({
    required this.deviceRepository,
    required this.historyRepository,
    required this.adService,
  });

  final Rx<DeviceModel?> localDevice = Rx<DeviceModel?>(null);
  final RxInt totalTransferredBytes = 0.obs;
  final RxBool isAdLoaded = false.obs;

  BannerAd? bannerAd;

  @override
  void onInit() {
    super.onInit();
    _loadDeviceAndStats();
    _initBannerAd();
  }

  Future<void> _loadDeviceAndStats() async {
    localDevice.value = await deviceRepository.getLocalDevice();
    totalTransferredBytes.value = historyRepository.getTotalTransferredBytes();
  }

  void _initBannerAd() {
    bannerAd = adService.createBannerAd(
      onAdLoaded: () {
        isAdLoaded.value = true;
      },
      onAdFailedToLoad: (_) {
        isAdLoaded.value = false;
      },
    );
    bannerAd?.load();
  }

  void goToSend() => Get.toNamed(AppRoutes.sender);
  void goToReceive() => Get.toNamed(AppRoutes.receiver);
  void goToHistory() => Get.toNamed(AppRoutes.transferHistory);
  void goToDuplicates() => Get.toNamed(AppRoutes.duplicateFiles);

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }
}
