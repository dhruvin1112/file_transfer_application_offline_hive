import 'dart:io';
import 'package:crypto/crypto.dart';

class AppUtils {
  AppUtils._();

  /// Formats byte size into human readable string (KB, MB, GB)
  static String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  /// Formats transfer speed (bytes per second) into human readable string (MB/s)
  static String formatSpeed(double bytesPerSecond) {
    if (bytesPerSecond <= 0) return '0 B/s';
    return '${formatBytes(bytesPerSecond.round())}/s';
  }

  /// Calculates SHA-256 checksum of a file without loading entire file into memory
  static Future<String> calculateSha256(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('File does not exist', filePath);
    }
    final output = await sha256.bind(file.openRead()).first;
    return output.toString();
  }

  /// Calculates estimated remaining time in seconds
  static int calculateRemainingSeconds({
    required int totalBytes,
    required int transferredBytes,
    required double bytesPerSecond,
  }) {
    if (bytesPerSecond <= 0) return 0;
    final remainingBytes = totalBytes - transferredBytes;
    if (remainingBytes <= 0) return 0;
    return (remainingBytes / bytesPerSecond).round();
  }

  /// Formats remaining seconds into mm:ss or hh:mm:ss
  static String formatDuration(int totalSeconds) {
    if (totalSeconds <= 0) return '00:00';
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
