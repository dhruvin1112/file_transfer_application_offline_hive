import 'package:get/get.dart';
import '../../core/services/duplicate_file_service.dart';
import '../../data/repositories/file_repository.dart';

class DuplicateFilesController extends GetxController {
  final FileRepository fileRepository;

  DuplicateFilesController({required this.fileRepository});

  final RxList<DuplicateGroup> duplicateGroups = <DuplicateGroup>[].obs;
  final RxBool isScanning = false.obs;

  Future<void> scanForDuplicates() async {
    isScanning.value = true;
    try {
      final pickedFiles = await fileRepository.pickFiles();
      if (pickedFiles.isNotEmpty) {
        final results = await fileRepository.scanDuplicates(pickedFiles);
        duplicateGroups.assignAll(results);
      }
    } finally {
      isScanning.value = false;
    }
  }
}
