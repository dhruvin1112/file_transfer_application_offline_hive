import 'package:get/get.dart';
import '../../data/repositories/contact_repository.dart';
import '../../data/repositories/file_repository.dart';
import 'file_selection_controller.dart';

class FileSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FileSelectionController>(
      () => FileSelectionController(
        fileRepository: Get.find<FileRepository>(),
        contactRepository: Get.find<ContactRepository>(),
      ),
    );
  }
}
