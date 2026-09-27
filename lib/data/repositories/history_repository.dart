import '../../core/services/local_storage_service.dart';
import '../models/transfer_history_model.dart';

class HistoryRepository {
  final LocalStorageService _storageService;

  HistoryRepository(this._storageService);

  /// Retrieves all transfer history records sorted by latest first
  List<TransferHistoryModel> getAllHistory() => _storageService.getHistory();

  /// Deletes a specific history record
  Future<void> deleteHistory(String transferId) =>
      _storageService.deleteHistory(transferId);

  /// Clears the entire transfer history box
  Future<void> clearAllHistory() => _storageService.clearHistory();

  /// Retrieves total cumulative bytes transferred
  int getTotalTransferredBytes() => _storageService.totalTransferredBytes;
}
