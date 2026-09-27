import 'package:get/get.dart';
import '../../modules/device_connection/device_connection_binding.dart';
import '../../modules/device_connection/device_connection_view.dart';
import '../../modules/duplicate_files/duplicate_files_binding.dart';
import '../../modules/duplicate_files/duplicate_files_view.dart';
import '../../modules/file_selection/file_selection_binding.dart';
import '../../modules/file_selection/file_selection_view.dart';
import '../../modules/home/home_binding.dart';
import '../../modules/home/home_view.dart';
import '../../modules/onboarding/onboarding_binding.dart';
import '../../modules/onboarding/onboarding_view.dart';
import '../../modules/qr/qr_binding.dart';
import '../../modules/qr/qr_view.dart';
import '../../modules/receiver/receiver_binding.dart';
import '../../modules/receiver/receiver_view.dart';
import '../../modules/sender/sender_binding.dart';
import '../../modules/sender/sender_view.dart';
import '../../modules/splash/splash_binding.dart';
import '../../modules/splash/splash_view.dart';
import '../../modules/transfer/transfer_binding.dart';
import '../../modules/transfer/transfer_view.dart';
import '../../modules/transfer_history/transfer_history_binding.dart';
import '../../modules/transfer_history/transfer_history_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.sender,
      page: () => const SenderView(),
      binding: SenderBinding(),
    ),
    GetPage(
      name: AppRoutes.receiver,
      page: () => const ReceiverView(),
      binding: ReceiverBinding(),
    ),
    GetPage(
      name: AppRoutes.deviceConnection,
      page: () => const DeviceConnectionView(),
      binding: DeviceConnectionBinding(),
    ),
    GetPage(
      name: AppRoutes.qr,
      page: () => const QrView(),
      binding: QrBinding(),
    ),
    GetPage(
      name: AppRoutes.fileSelection,
      page: () => const FileSelectionView(),
      binding: FileSelectionBinding(),
    ),
    GetPage(
      name: AppRoutes.transfer,
      page: () => const TransferView(),
      binding: TransferBinding(),
    ),
    GetPage(
      name: AppRoutes.transferHistory,
      page: () => const TransferHistoryView(),
      binding: TransferHistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.duplicateFiles,
      page: () => const DuplicateFilesView(),
      binding: DuplicateFilesBinding(),
    ),
  ];
}
