import '../../shared/enums/transfer_status.dart';

class TransferHistoryModel {
  final String transferId;
  final String deviceName;
  final int totalFiles;
  final int totalSize;
  final DateTime date;
  final TransferStatus status;
  final bool isSender;

  const TransferHistoryModel({
    required this.transferId,
    required this.deviceName,
    required this.totalFiles,
    required this.totalSize,
    required this.date,
    required this.status,
    required this.isSender,
  });

  TransferHistoryModel copyWith({
    String? transferId,
    String? deviceName,
    int? totalFiles,
    int? totalSize,
    DateTime? date,
    TransferStatus? status,
    bool? isSender,
  }) {
    return TransferHistoryModel(
      transferId: transferId ?? this.transferId,
      deviceName: deviceName ?? this.deviceName,
      totalFiles: totalFiles ?? this.totalFiles,
      totalSize: totalSize ?? this.totalSize,
      date: date ?? this.date,
      status: status ?? this.status,
      isSender: isSender ?? this.isSender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transferId': transferId,
      'deviceName': deviceName,
      'totalFiles': totalFiles,
      'totalSize': totalSize,
      'date': date.toIso8601String(),
      'status': status.name,
      'isSender': isSender,
    };
  }

  factory TransferHistoryModel.fromMap(Map<String, dynamic> map) {
    return TransferHistoryModel(
      transferId: map['transferId'] as String? ?? '',
      deviceName: map['deviceName'] as String? ?? 'Unknown Device',
      totalFiles: map['totalFiles'] as int? ?? 0,
      totalSize: map['totalSize'] as int? ?? 0,
      date: map['date'] != null
          ? DateTime.parse(map['date'] as String)
          : DateTime.now(),
      status: TransferStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TransferStatus.completed,
      ),
      isSender: map['isSender'] as bool? ?? true,
    );
  }
}
