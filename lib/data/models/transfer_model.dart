import '../../shared/enums/transfer_status.dart';
import 'device_model.dart';
import 'file_model.dart';

class TransferModel {
  final String transferId;
  final DeviceModel? senderDevice;
  final DeviceModel? receiverDevice;
  final List<FileModel> files;
  final int totalSize;
  final int transferredSize;
  final double transferProgress; // 0.0 to 1.0
  final double transferSpeed; // bytes per second
  final TransferStatus transferStatus;
  final DateTime startTime;
  final DateTime? completionTime;
  final String? errorMessage;
  final String? currentTransferringFileName;

  const TransferModel({
    required this.transferId,
    this.senderDevice,
    this.receiverDevice,
    this.files = const [],
    this.totalSize = 0,
    this.transferredSize = 0,
    this.transferProgress = 0.0,
    this.transferSpeed = 0.0,
    this.transferStatus = TransferStatus.pending,
    required this.startTime,
    this.completionTime,
    this.errorMessage,
    this.currentTransferringFileName,
  });

  TransferModel copyWith({
    String? transferId,
    DeviceModel? senderDevice,
    DeviceModel? receiverDevice,
    List<FileModel>? files,
    int? totalSize,
    int? transferredSize,
    double? transferProgress,
    double? transferSpeed,
    TransferStatus? transferStatus,
    DateTime? startTime,
    DateTime? completionTime,
    String? errorMessage,
    String? currentTransferringFileName,
  }) {
    return TransferModel(
      transferId: transferId ?? this.transferId,
      senderDevice: senderDevice ?? this.senderDevice,
      receiverDevice: receiverDevice ?? this.receiverDevice,
      files: files ?? this.files,
      totalSize: totalSize ?? this.totalSize,
      transferredSize: transferredSize ?? this.transferredSize,
      transferProgress: transferProgress ?? this.transferProgress,
      transferSpeed: transferSpeed ?? this.transferSpeed,
      transferStatus: transferStatus ?? this.transferStatus,
      startTime: startTime ?? this.startTime,
      completionTime: completionTime ?? this.completionTime,
      errorMessage: errorMessage ?? this.errorMessage,
      currentTransferringFileName:
          currentTransferringFileName ?? this.currentTransferringFileName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transferId': transferId,
      'senderDevice': senderDevice?.toMap(),
      'receiverDevice': receiverDevice?.toMap(),
      'files': files.map((f) => f.toMap()).toList(),
      'totalSize': totalSize,
      'transferredSize': transferredSize,
      'transferProgress': transferProgress,
      'transferSpeed': transferSpeed,
      'transferStatus': transferStatus.name,
      'startTime': startTime.toIso8601String(),
      'completionTime': completionTime?.toIso8601String(),
      'errorMessage': errorMessage,
      'currentTransferringFileName': currentTransferringFileName,
    };
  }

  factory TransferModel.fromMap(Map<String, dynamic> map) {
    return TransferModel(
      transferId: map['transferId'] as String? ?? '',
      senderDevice: map['senderDevice'] != null
          ? DeviceModel.fromMap(map['senderDevice'] as Map<String, dynamic>)
          : null,
      receiverDevice: map['receiverDevice'] != null
          ? DeviceModel.fromMap(map['receiverDevice'] as Map<String, dynamic>)
          : null,
      files: (map['files'] as List<dynamic>?)
              ?.map((f) => FileModel.fromMap(f as Map<String, dynamic>))
              .toList() ??
          [],
      totalSize: map['totalSize'] as int? ?? 0,
      transferredSize: map['transferredSize'] as int? ?? 0,
      transferProgress: (map['transferProgress'] as num?)?.toDouble() ?? 0.0,
      transferSpeed: (map['transferSpeed'] as num?)?.toDouble() ?? 0.0,
      transferStatus: TransferStatus.values.firstWhere(
        (e) => e.name == map['transferStatus'],
        orElse: () => TransferStatus.pending,
      ),
      startTime: map['startTime'] != null
          ? DateTime.parse(map['startTime'] as String)
          : DateTime.now(),
      completionTime: map['completionTime'] != null
          ? DateTime.parse(map['completionTime'] as String)
          : null,
      errorMessage: map['errorMessage'] as String?,
      currentTransferringFileName:
          map['currentTransferringFileName'] as String?,
    );
  }
}
