import 'package:get/get.dart';
import '../../data/repositories/file_repository.dart';
import 'sender_controller.dart';

class SenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SenderController>(
      () => SenderController(
        fileRepository: Get.find<FileRepository>(),
      ),
    );
  }
}
