class DeviceModel {
  final String id;
  final String deviceName;
  final String platform; // 'Android' or 'iOS'
  final String connectionAddress;
  final int port;
  final bool isConnected;

  const DeviceModel({
    required this.id,
    required this.deviceName,
    required this.platform,
    required this.connectionAddress,
    this.port = 8888,
    this.isConnected = false,
  });

  DeviceModel copyWith({
    String? id,
    String? deviceName,
    String? platform,
    String? connectionAddress,
    int? port,
    bool? isConnected,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      deviceName: deviceName ?? this.deviceName,
      platform: platform ?? this.platform,
      connectionAddress: connectionAddress ?? this.connectionAddress,
      port: port ?? this.port,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deviceName': deviceName,
      'platform': platform,
      'connectionAddress': connectionAddress,
      'port': port,
      'isConnected': isConnected,
    };
  }

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      id: map['id'] as String? ?? '',
      deviceName: map['deviceName'] as String? ?? 'Unknown Device',
      platform: map['platform'] as String? ?? 'Unknown',
      connectionAddress: map['connectionAddress'] as String? ?? '',
      port: map['port'] as int? ?? 8888,
      isConnected: map['isConnected'] as bool? ?? false,
    );
  }

  @override
  String toString() =>
      'DeviceModel(id: $id, name: $deviceName, platform: $platform, addr: $connectionAddress:$port)';
}
