import 'package:get/get.dart';
import '../../data/repositories/file_repository.dart';
import 'duplicate_files_controller.dart';

class DuplicateFilesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DuplicateFilesController>(
      () => DuplicateFilesController(
        fileRepository: Get.find<FileRepository>(),
      ),
    );
  }
}
