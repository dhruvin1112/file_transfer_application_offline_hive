import 'package:hive_flutter/hive_flutter.dart';
import 'hive_boxes.dart';
import '../models/transfer_history_model.dart';
import '../models/transfer_model.dart';

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
    await HiveBoxes.openBoxes();
  }

  // Transfer History Operations
  Future<void> saveTransferHistory(TransferHistoryModel history) async {
    await HiveBoxes.historyBox.put(history.transferId, history.toMap());
  }

  List<TransferHistoryModel> getAllTransferHistory() {
    final box = HiveBoxes.historyBox;
    final List<TransferHistoryModel> list = [];
    for (final key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        list.add(TransferHistoryModel.fromMap(Map<String, dynamic>.from(data)));
      }
    }
    // Sort newest first
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<void> deleteTransferHistory(String transferId) async {
    await HiveBoxes.historyBox.delete(transferId);
  }

  Future<void> clearAllHistory() async {
    await HiveBoxes.historyBox.clear();
  }

  // Transfer Session Metadata Operations (for recovery / resume architecture)
  Future<void> saveTransferSession(TransferModel transfer) async {
    await HiveBoxes.metadataBox.put(transfer.transferId, transfer.toMap());
  }

  TransferModel? getTransferSession(String transferId) {
    final data = HiveBoxes.metadataBox.get(transferId);
    if (data == null) return null;
    return TransferModel.fromMap(Map<String, dynamic>.from(data));
  }

  Future<void> deleteTransferSession(String transferId) async {
    await HiveBoxes.metadataBox.delete(transferId);
  }
}
