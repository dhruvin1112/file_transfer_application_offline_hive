import 'package:get/get.dart';
import '../../data/models/file_model.dart';
import '../../data/repositories/contact_repository.dart';
import '../../data/repositories/file_repository.dart';
import '../../shared/enums/file_type.dart';

class FileSelectionController extends GetxController {
  final FileRepository fileRepository;
  final ContactRepository contactRepository;

  FileSelectionController({
    required this.fileRepository,
    required this.contactRepository,
  });

  final RxList<FileModel> selectedFiles = <FileModel>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> pickMedia(FileType type) async {
    isLoading.value = true;
    try {
      final files = await fileRepository.pickFiles(type: type);
      selectedFiles.addAll(files);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickContacts() async {
    isLoading.value = true;
    try {
      final contacts = await contactRepository.getContacts();
      final vcfFile = await contactRepository.exportContactsToVcf(contacts);
      if (vcfFile != null) {
        selectedFiles.add(vcfFile);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void removeFile(FileModel file) {
    selectedFiles.remove(file);
  }

  void confirmSelection() {
    Get.back(result: selectedFiles.toList());
  }
}
