import 'package:get/get.dart';
import '../../core/services/ad_service.dart';
import '../../data/repositories/transfer_repository.dart';
import 'transfer_controller.dart';

class TransferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferController>(
      () => TransferController(
        transferRepository: Get.find<TransferRepository>(),
        adService: Get.find<AdService>(),
      ),
    );
  }
}
