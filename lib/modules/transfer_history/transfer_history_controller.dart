import 'package:get/get.dart';
import '../../data/models/transfer_history_model.dart';
import '../../data/repositories/history_repository.dart';

class TransferHistoryController extends GetxController {
  final HistoryRepository historyRepository;

  TransferHistoryController({required this.historyRepository});

  final RxList<TransferHistoryModel> historyList = <TransferHistoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() {
    historyList.assignAll(historyRepository.getAllHistory());
  }

  Future<void> deleteItem(String transferId) async {
    await historyRepository.deleteHistory(transferId);
    loadHistory();
  }

  Future<void> clearAll() async {
    await historyRepository.clearAllHistory();
    loadHistory();
  }
}
