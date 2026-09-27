class AppConstants {
  AppConstants._();

  static const String appName = 'DropShare';
  static const String appVersion = '1.0.0';

  // Network & Socket Configuration
  static const int defaultTransferPort = 8888;
  static const int defaultDiscoveryPort = 8889;
  static const int socketTimeoutSeconds = 30;
  static const int connectionHandshakeTimeoutMs = 10000;

  // File Transfer Engine Configuration
  // Default chunk size is 64 KB (65536 bytes), balance between throughput and memory
  static const int defaultChunkSize = 64 * 1024;
  static const int bufferQueueCapacity = 16;
  static const int speedSampleWindowMs = 1000;

  // Service Type for local mDNS discovery
  static const String mdnsServiceType = '_filetransfer._tcp';
}
