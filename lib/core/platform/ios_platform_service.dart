import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../services/native_channel_service.dart';
import 'platform_transfer_service.dart';

class IOSPlatformService implements PlatformTransferService {
  final NativeChannelService _nativeChannelService;

  IOSPlatformService(this._nativeChannelService);

  @override
  Future<String> getDevicePlatformName() async => 'iOS';

  @override
  Future<bool> isHotspotSupported() async {
    // iOS Personal Hotspot cannot be started programmatically without private APIs
    return false;
  }

  @override
  Future<bool> canAccessNativeFileSystem() async {
    // iOS is sandboxed to app containers
    return false;
  }

  @override
  Future<String?> getRecommendedSaveDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final receivedDir = Directory('${appDocDir.path}/ReceivedFiles');
    if (!await receivedDir.exists()) {
      await receivedDir.create(recursive: true);
    }
    return receivedDir.path;
  }

  /// iOS-specific: Open Settings via method channel
  Future<bool> openSettings() => _nativeChannelService.openAppSettings();
}
