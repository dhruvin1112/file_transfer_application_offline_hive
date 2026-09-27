import 'package:get/get.dart';
import '../../data/repositories/history_repository.dart';
import 'transfer_history_controller.dart';

class TransferHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferHistoryController>(
      () => TransferHistoryController(
        historyRepository: Get.find<HistoryRepository>(),
      ),
    );
  }
}
