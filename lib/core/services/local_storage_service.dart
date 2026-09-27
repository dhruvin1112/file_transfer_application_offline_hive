import '../../data/local/hive_service.dart';
import '../../data/models/transfer_history_model.dart';
import '../../data/models/transfer_model.dart';
import 'shared_preferences_service.dart';

class LocalStorageService {
  final HiveService hiveService;
  final SharedPreferencesService prefsService;

  LocalStorageService({
    required this.hiveService,
    required this.prefsService,
  });

  // SharedPreferences Delegation
  bool get isOnboardingCompleted => prefsService.isOnboardingCompleted;
  Future<void> setOnboardingCompleted(bool value) =>
      prefsService.setOnboardingCompleted(value);

  String? get deviceCustomName => prefsService.deviceCustomName;
  Future<void> setDeviceCustomName(String name) =>
      prefsService.setDeviceCustomName(name);

  bool get autoAcceptTransfers => prefsService.autoAcceptTransfers;
  Future<void> setAutoAcceptTransfers(bool value) =>
      prefsService.setAutoAcceptTransfers(value);

  int get totalTransferredBytes => prefsService.totalTransferredBytes;
  Future<void> recordTransferredBytes(int bytes) =>
      prefsService.incrementTransferredBytes(bytes);

  // Hive History Delegation
  Future<void> saveHistory(TransferHistoryModel history) =>
      hiveService.saveTransferHistory(history);

  List<TransferHistoryModel> getHistory() =>
      hiveService.getAllTransferHistory();

  Future<void> deleteHistory(String id) =>
      hiveService.deleteTransferHistory(id);

  Future<void> clearHistory() => hiveService.clearAllHistory();

  // Hive Session Delegation
  Future<void> saveSession(TransferModel transfer) =>
      hiveService.saveTransferSession(transfer);

  TransferModel? getSession(String transferId) =>
      hiveService.getTransferSession(transferId);

  Future<void> deleteSession(String transferId) =>
      hiveService.deleteTransferSession(transferId);
}
