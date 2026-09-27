import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../data/models/device_model.dart';
import '../errors/app_exception.dart';
import '../utils/validators.dart';

class QrPairingPayload {
  final String sessionId;
  final String token;
  final DeviceModel device;
  final DateTime timestamp;

  QrPairingPayload({
    required this.sessionId,
    required this.token,
    required this.device,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'token': token,
      'device': device.toMap(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String toJsonString() => jsonEncode(toMap());

  factory QrPairingPayload.fromMap(Map<String, dynamic> map) {
    return QrPairingPayload(
      sessionId: map['sessionId'] as String? ?? '',
      token: map['token'] as String? ?? '',
      device: DeviceModel.fromMap(map['device'] as Map<String, dynamic>),
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.now(),
    );
  }
}

class QrService {
  final _uuid = const Uuid();

  /// Generates pairing payload string to be encoded into QR code by Sender/Receiver
  String generatePairingData({
    required DeviceModel localDevice,
  }) {
    final sessionId = _uuid.v4();
    final token = _uuid.v4().substring(0, 12);

    final payload = QrPairingPayload(
      sessionId: sessionId,
      token: token,
      device: localDevice,
      timestamp: DateTime.now(),
    );

    return payload.toJsonString();
  }

  /// Parses and validates QR code scanned string
  QrPairingPayload parseScannedData(String rawData) {
    try {
      final map = jsonDecode(rawData) as Map<String, dynamic>;
      final payload = QrPairingPayload.fromMap(map);

      if (payload.sessionId.isEmpty) {
        throw ConnectionException('Invalid QR code: missing session ID');
      }
      if (!Validators.isValidIpAddress(payload.device.connectionAddress)) {
        throw ConnectionException('Invalid QR code: invalid host IP address');
      }
      if (!Validators.isValidPort(payload.device.port)) {
        throw ConnectionException('Invalid QR code: invalid port number');
      }

      return payload;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ConnectionException('Failed to decode QR code data: $e');
    }
  }
}
