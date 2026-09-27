import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/device_model.dart';
import '../../data/models/file_model.dart';
import '../../data/repositories/file_repository.dart';
import '../../shared/enums/file_type.dart';

class SenderController extends GetxController {
  final FileRepository fileRepository;

  SenderController({required this.fileRepository});

  final RxList<FileModel> selectedFiles = <FileModel>[].obs;
  final RxInt totalSelectedSize = 0.obs;
  final RxBool isSelecting = false.obs;
  final RxBool isConnected = false.obs;
  final Rx<DeviceModel?> connectedDevice = Rx<DeviceModel?>(null);

  Future<void> pickFiles(FileType type) async {
    isSelecting.value = true;
    try {
      final picked = await fileRepository.pickFiles(type: type);
      selectedFiles.addAll(picked);
      _recalculateTotalSize();
    } finally {
      isSelecting.value = false;
    }
  }

  void removeFile(FileModel file) {
    selectedFiles.remove(file);
    _recalculateTotalSize();
  }

  void _recalculateTotalSize() {
    totalSelectedSize.value =
        selectedFiles.fold<int>(0, (sum, item) => sum + item.size);
  }

  void proceedToPairing() {
    if (selectedFiles.isEmpty) {
      Get.snackbar('No Files Selected', 'Please select at least one file to send.');
      return;
    }
    Get.toNamed(
      AppRoutes.deviceConnection,
      arguments: {'mode': 'sender', 'files': selectedFiles.toList()},
    );
  }
}
