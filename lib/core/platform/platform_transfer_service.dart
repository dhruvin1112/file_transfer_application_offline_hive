abstract class PlatformTransferService {
  Future<String> getDevicePlatformName();
  Future<bool> isHotspotSupported();
  Future<bool> canAccessNativeFileSystem();
  Future<String?> getRecommendedSaveDirectory();
}
