import 'dart:io';
import 'package:get/get.dart';
import '../../core/platform/android_platform_service.dart';
import '../../core/platform/ios_platform_service.dart';
import '../../core/platform/platform_transfer_service.dart';
import '../../core/services/ad_service.dart';
import '../../core/services/connection_service.dart';
import '../../core/services/contact_service.dart';
import '../../core/services/device_discovery_service.dart';
import '../../core/services/duplicate_file_service.dart';
import '../../core/services/file_transfer_service.dart';
import '../../core/services/local_network_service.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/services/native_channel_service.dart';
import '../../core/services/permission_service.dart';
import '../../core/services/qr_service.dart';
import '../../core/services/shared_preferences_service.dart';
import '../../core/services/socket_service.dart';
import '../../data/repositories/contact_repository.dart';
import '../../data/repositories/device_repository.dart';
import '../../data/repositories/file_repository.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/repositories/transfer_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services
    Get.put<PermissionService>(PermissionService(), permanent: true);
    Get.put<LocalNetworkService>(LocalNetworkService(), permanent: true);
    Get.put<SocketService>(SocketService(), permanent: true);
    Get.put<QrService>(QrService(), permanent: true);
    Get.put<DeviceDiscoveryService>(DeviceDiscoveryService(), permanent: true);
    Get.put<DuplicateFileService>(DuplicateFileService(), permanent: true);
    Get.put<NativeChannelService>(NativeChannelService(), permanent: true);

    Get.put<ConnectionService>(
      ConnectionService(Get.find<SocketService>()),
      permanent: true,
    );

    Get.put<FileTransferService>(FileTransferService(), permanent: true);

    Get.put<ContactService>(
      ContactService(Get.find<PermissionService>()),
      permanent: true,
    );

    // Platform-Specific Services
    if (Platform.isAndroid) {
      Get.put<PlatformTransferService>(
        AndroidPlatformService(Get.find<NativeChannelService>()),
        permanent: true,
      );
    } else if (Platform.isIOS) {
      Get.put<PlatformTransferService>(
        IOSPlatformService(Get.find<NativeChannelService>()),
        permanent: true,
      );
    }

    // Repositories
    Get.put<DeviceRepository>(
      DeviceRepository(
        discoveryService: Get.find<DeviceDiscoveryService>(),
        networkService: Get.find<LocalNetworkService>(),
        nativeChannelService: Get.find<NativeChannelService>(),
        prefsService: Get.find<SharedPreferencesService>(),
      ),
      permanent: true,
    );

    Get.put<FileRepository>(
      FileRepository(
        permissionService: Get.find<PermissionService>(),
        duplicateFileService: Get.find<DuplicateFileService>(),
      ),
      permanent: true,
    );

    Get.put<TransferRepository>(
      TransferRepository(
        fileTransferService: Get.find<FileTransferService>(),
        connectionService: Get.find<ConnectionService>(),
        storageService: Get.find<LocalStorageService>(),
        adService: Get.find<AdService>(),
      ),
      permanent: true,
    );

    Get.put<ContactRepository>(
      ContactRepository(Get.find<ContactService>()),
      permanent: true,
    );

    Get.put<HistoryRepository>(
      HistoryRepository(Get.find<LocalStorageService>()),
      permanent: true,
    );
  }
}
