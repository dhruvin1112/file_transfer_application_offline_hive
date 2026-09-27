import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../services/native_channel_service.dart';
import 'platform_transfer_service.dart';

class AndroidPlatformService implements PlatformTransferService {
  final NativeChannelService _nativeChannelService;

  AndroidPlatformService(this._nativeChannelService);

  @override
  Future<String> getDevicePlatformName() async => 'Android';

  @override
  Future<bool> isHotspotSupported() async => true;

  @override
  Future<bool> canAccessNativeFileSystem() async => true;

  @override
  Future<String?> getRecommendedSaveDirectory() async {
    try {
      // For Android, prefer external downloads or documents
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final downloadDir = Directory('${directory.path}/DropShare');
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        return downloadDir.path;
      }
    } catch (_) {}

    final appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  /// Android-specific: Open Wi-Fi settings via method channel
  Future<bool> openWifiSettings() => _nativeChannelService.openWifiSettings();
}
