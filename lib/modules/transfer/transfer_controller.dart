import 'package:get/get.dart';
import '../../core/services/ad_service.dart';
import '../../data/models/device_model.dart';
import '../../data/models/file_model.dart';
import '../../data/repositories/transfer_repository.dart';
import '../../shared/enums/transfer_status.dart';

class TransferController extends GetxController {
  final TransferRepository transferRepository;
  final AdService adService;

  TransferController({
    required this.transferRepository,
    required this.adService,
  });

  final RxBool isConnected = true.obs;
  final RxBool isTransferring = false.obs;
  final RxDouble transferProgress = 0.0.obs;
  final RxDouble transferSpeed = 0.0.obs;
  final RxList<FileModel> selectedFiles = <FileModel>[].obs;
  final Rx<DeviceModel?> connectedDevice = Rx<DeviceModel?>(null);
  final Rx<TransferStatus> transferStatus = TransferStatus.preparing.obs;
  final Rx<String?> transferError = Rx<String?>(null);
  final RxString currentFileName = ''.obs;

  bool isSender = true;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['targetDevice'] != null) {
        connectedDevice.value = args['targetDevice'] as DeviceModel;
      }
      if (args['files'] != null) {
        selectedFiles.assignAll(List<FileModel>.from(args['files'] as List));
      }
      if (args['isSender'] != null) {
        isSender = args['isSender'] as bool;
      }
    }

    _listenToTransferUpdates();
  }

  void _listenToTransferUpdates() {
    transferRepository.onTransferUpdated.listen((updated) {
      transferStatus.value = updated.transferStatus;
      transferProgress.value = updated.transferProgress;
      transferSpeed.value = updated.transferSpeed;
      currentFileName.value = updated.currentTransferringFileName ?? '';
      transferError.value = updated.errorMessage;

      if (updated.transferStatus == TransferStatus.transferring) {
        isTransferring.value = true;
      } else if (updated.transferStatus.isTerminal) {
        isTransferring.value = false;
        if (updated.transferStatus == TransferStatus.completed) {
          // On transfer completion, ad can safely be shown without interrupting transfer
          adService.showInterstitialAd();
        }
      }
    });
  }

  void cancelTransfer() {
    transferRepository.cancelTransfer();
    transferStatus.value = TransferStatus.cancelled;
    isTransferring.value = false;
  }

  void finishSession() {
    transferRepository.disconnectSession();
    Get.back();
  }
}
