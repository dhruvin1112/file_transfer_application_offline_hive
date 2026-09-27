import 'dart:io';
import '../../core/services/ad_service.dart';
import '../../core/services/connection_service.dart';
import '../../core/services/file_transfer_service.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/services/qr_service.dart';
import '../models/file_model.dart';
import '../models/transfer_history_model.dart';
import '../models/transfer_model.dart';

class TransferRepository {
  final FileTransferService fileTransferService;
  final ConnectionService connectionService;
  final LocalStorageService storageService;
  final AdService adService;

  TransferRepository({
    required this.fileTransferService,
    required this.connectionService,
    required this.storageService,
    required this.adService,
  });

  Stream<TransferModel> get onTransferUpdated =>
      fileTransferService.onTransferUpdated;

  TransferModel? get activeTransfer => fileTransferService.activeTransfer;

  /// Starts sending files to the connected peer
  Future<void> sendFiles({
    required Socket socket,
    required List<FileModel> files,
    required TransferModel initialTransfer,
  }) async {
    adService.setTransferActive(true);
    try {
      await fileTransferService.sendFiles(
        socket: socket,
        files: files,
        initialTransfer: initialTransfer,
      );

      // Save to history upon completion
      final finalTransfer = fileTransferService.activeTransfer ?? initialTransfer;
      await _saveHistoryRecord(finalTransfer, isSender: true);
      await storageService.recordTransferredBytes(finalTransfer.transferredSize);
    } finally {
      adService.setTransferActive(false);
    }
  }

  /// Starts receiving files from connected socket
  Future<void> receiveFile({
    required Socket socket,
    required String saveDirectoryPath,
    required FileModel incomingMetadata,
    required TransferModel initialTransfer,
  }) async {
    adService.setTransferActive(true);
    try {
      await fileTransferService.receiveFile(
        socket: socket,
        saveDirectoryPath: saveDirectoryPath,
        incomingMetadata: incomingMetadata,
        initialTransfer: initialTransfer,
      );

      final finalTransfer = fileTransferService.activeTransfer ?? initialTransfer;
      await _saveHistoryRecord(finalTransfer, isSender: false);
      await storageService.recordTransferredBytes(finalTransfer.transferredSize);
    } finally {
      adService.setTransferActive(false);
    }
  }

  /// Cancels the ongoing transfer
  void cancelTransfer() {
    fileTransferService.cancelTransfer();
    adService.setTransferActive(false);
  }

  /// Disconnects the peer connection session
  Future<void> disconnectSession() => connectionService.disconnect();

  /// Connects using scanned QR payload
  Future<void> connectWithQrPayload(QrPairingPayload payload) =>
      connectionService.connectWithQrPayload(payload);

  Future<void> _saveHistoryRecord(TransferModel transfer, {required bool isSender}) async {
    final history = TransferHistoryModel(
      transferId: transfer.transferId,
      deviceName: isSender
          ? (transfer.receiverDevice?.deviceName ?? 'Unknown Receiver')
          : (transfer.senderDevice?.deviceName ?? 'Unknown Sender'),
      totalFiles: transfer.files.length,
      totalSize: transfer.totalSize,
      date: DateTime.now(),
      status: transfer.transferStatus,
      isSender: isSender,
    );
    await storageService.saveHistory(history);
  }
}
