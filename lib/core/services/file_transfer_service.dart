import 'dart:async';
import 'dart:io';
import '../../data/models/file_model.dart';
import '../../data/models/transfer_model.dart';
import '../../shared/enums/transfer_status.dart';
import '../constants/app_constants.dart';
import '../errors/app_exception.dart';
import '../utils/app_utils.dart';

typedef TransferProgressCallback = void Function(TransferModel updatedTransfer);

class FileTransferService {
  final StreamController<TransferModel> _transferStreamController =
      StreamController<TransferModel>.broadcast();

  Stream<TransferModel> get onTransferUpdated => _transferStreamController.stream;

  TransferModel? _activeTransfer;
  TransferModel? get activeTransfer => _activeTransfer;

  bool _isCancelled = false;

  /// Cancels any currently active file transfer stream
  void cancelTransfer() {
    _isCancelled = true;
    if (_activeTransfer != null) {
      _activeTransfer = _activeTransfer!.copyWith(
        transferStatus: TransferStatus.cancelled,
        completionTime: DateTime.now(),
        errorMessage: 'Transfer was cancelled by user',
      );
      _transferStreamController.add(_activeTransfer!);
    }
  }

  /// Sends a list of files over a connected Socket using streaming chunks
  Future<void> sendFiles({
    required Socket socket,
    required List<FileModel> files,
    required TransferModel initialTransfer,
  }) async {
    _isCancelled = false;
    _activeTransfer = initialTransfer.copyWith(
      transferStatus: TransferStatus.transferring,
      startTime: DateTime.now(),
    );
    _transferStreamController.add(_activeTransfer!);

    int totalBytesTransferred = 0;
    final stopwatch = Stopwatch()..start();
    var lastSampleTime = stopwatch.elapsedMilliseconds;
    var bytesSinceLastSample = 0;

    try {
      for (final fileModel in files) {
        if (_isCancelled) break;

        final file = File(fileModel.path);
        if (!await file.exists()) {
          throw FileSystemException('File not found: ${fileModel.path}');
        }

        final fileStream = file.openRead();

        _activeTransfer = _activeTransfer!.copyWith(
          currentTransferringFileName: fileModel.name,
        );
        _transferStreamController.add(_activeTransfer!);

        // Stream file chunks directly to socket sink
        await for (final chunk in fileStream) {
          if (_isCancelled) break;

          socket.add(chunk);
          await socket.flush();

          totalBytesTransferred += chunk.length;
          bytesSinceLastSample += chunk.length;

          // Speed & Progress calculation
          final now = stopwatch.elapsedMilliseconds;
          final timeDiff = now - lastSampleTime;
          double currentSpeed = _activeTransfer!.transferSpeed;

          if (timeDiff >= AppConstants.speedSampleWindowMs) {
            currentSpeed = (bytesSinceLastSample / (timeDiff / 1000.0));
            bytesSinceLastSample = 0;
            lastSampleTime = now;
          }

          final progress = initialTransfer.totalSize > 0
              ? (totalBytesTransferred / initialTransfer.totalSize).clamp(0.0, 1.0)
              : 0.0;

          _activeTransfer = _activeTransfer!.copyWith(
            transferredSize: totalBytesTransferred,
            transferProgress: progress,
            transferSpeed: currentSpeed,
          );
          _transferStreamController.add(_activeTransfer!);
        }

        // Verify SHA-256 if available
        if (fileModel.checksum != null && fileModel.checksum!.isNotEmpty) {
          final computedHash = await AppUtils.calculateSha256(file.path);
          if (computedHash.toLowerCase() != fileModel.checksum!.toLowerCase()) {
            throw ChecksumMismatchException(fileModel.name);
          }
        }
      }

      if (!_isCancelled) {
        _activeTransfer = _activeTransfer!.copyWith(
          transferStatus: TransferStatus.completed,
          completionTime: DateTime.now(),
          transferProgress: 1.0,
          transferSpeed: 0.0,
        );
        _transferStreamController.add(_activeTransfer!);
      }
    } catch (e) {
      _activeTransfer = _activeTransfer!.copyWith(
        transferStatus: TransferStatus.failed,
        completionTime: DateTime.now(),
        errorMessage: e.toString(),
      );
      _transferStreamController.add(_activeTransfer!);
      throw TransferException('Transfer failed: $e');
    } finally {
      stopwatch.stop();
    }
  }

  /// Receives a stream of files from a connected socket and writes to destination directory
  Future<void> receiveFile({
    required Socket socket,
    required String saveDirectoryPath,
    required FileModel incomingMetadata,
    required TransferModel initialTransfer,
  }) async {
    _isCancelled = false;
    _activeTransfer = initialTransfer.copyWith(
      transferStatus: TransferStatus.transferring,
      startTime: DateTime.now(),
      currentTransferringFileName: incomingMetadata.name,
    );
    _transferStreamController.add(_activeTransfer!);

    final targetFile = File('$saveDirectoryPath/${incomingMetadata.name}');
    final sink = targetFile.openWrite();

    int receivedBytes = 0;
    final stopwatch = Stopwatch()..start();
    var lastSampleTime = stopwatch.elapsedMilliseconds;
    var bytesSinceLastSample = 0;

    try {
      await for (final chunk in socket) {
        if (_isCancelled) break;

        sink.add(chunk);
        receivedBytes += chunk.length;
        bytesSinceLastSample += chunk.length;

        final now = stopwatch.elapsedMilliseconds;
        final timeDiff = now - lastSampleTime;
        double currentSpeed = _activeTransfer!.transferSpeed;

        if (timeDiff >= AppConstants.speedSampleWindowMs) {
          currentSpeed = (bytesSinceLastSample / (timeDiff / 1000.0));
          bytesSinceLastSample = 0;
          lastSampleTime = now;
        }

        final progress = incomingMetadata.size > 0
            ? (receivedBytes / incomingMetadata.size).clamp(0.0, 1.0)
            : 0.0;

        _activeTransfer = _activeTransfer!.copyWith(
          transferredSize: receivedBytes,
          transferProgress: progress,
          transferSpeed: currentSpeed,
        );
        _transferStreamController.add(_activeTransfer!);

        if (receivedBytes >= incomingMetadata.size) {
          break;
        }
      }

      await sink.flush();
      await sink.close();

      // Checksum integrity check
      if (incomingMetadata.checksum != null &&
          incomingMetadata.checksum!.isNotEmpty) {
        final computedHash = await AppUtils.calculateSha256(targetFile.path);
        if (computedHash.toLowerCase() != incomingMetadata.checksum!.toLowerCase()) {
          throw ChecksumMismatchException(incomingMetadata.name);
        }
      }

      if (!_isCancelled) {
        _activeTransfer = _activeTransfer!.copyWith(
          transferStatus: TransferStatus.completed,
          completionTime: DateTime.now(),
          transferProgress: 1.0,
          transferSpeed: 0.0,
        );
        _transferStreamController.add(_activeTransfer!);
      }
    } catch (e) {
      await sink.close();
      _activeTransfer = _activeTransfer!.copyWith(
        transferStatus: TransferStatus.failed,
        completionTime: DateTime.now(),
        errorMessage: e.toString(),
      );
      _transferStreamController.add(_activeTransfer!);
      throw TransferException('Receive stream failed: $e');
    } finally {
      stopwatch.stop();
    }
  }

  void dispose() {
    _transferStreamController.close();
  }
}
