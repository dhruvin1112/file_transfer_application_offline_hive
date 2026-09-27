import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Requests camera permission for QR code scanning
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Checks if camera permission is granted
  Future<bool> hasCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  /// Requests storage/media permissions tailored to platform version
  Future<bool> requestStoragePermissions() async {
    if (Platform.isAndroid) {
      // Android 13+ (SDK 33+) uses granular media permissions
      final photos = await Permission.photos.request();
      final videos = await Permission.videos.request();
      final audio = await Permission.audio.request();

      // If Android < 13, request standard storage
      final storage = await Permission.storage.request();

      return photos.isGranted ||
          videos.isGranted ||
          audio.isGranted ||
          storage.isGranted;
    } else if (Platform.isIOS) {
      final photos = await Permission.photos.request();
      return photos.isGranted || photos.isLimited;
    }
    return true;
  }

  /// Requests local network and nearby Wi-Fi devices permissions
  Future<bool> requestLocalNetworkPermissions() async {
    if (Platform.isAndroid) {
      // Android 13+ nearby wifi devices
      final nearby = await Permission.nearbyWifiDevices.request();
      final location = await Permission.locationWhenInUse.request();
      return nearby.isGranted || location.isGranted;
    } else if (Platform.isIOS) {
      // iOS manages local network permission via Info.plist and triggers prompt on first network bind
      return true;
    }
    return true;
  }

  /// Requests contacts permission for user-accessible contact sharing
  Future<bool> requestContactsPermission() async {
    final status = await Permission.contacts.request();
    return status.isGranted;
  }

  /// Opens application settings if permission is permanently denied
  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
