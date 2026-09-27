import 'package:flutter_test/flutter_test.dart';
import 'package:file_transfer_appplication/data/models/device_model.dart';
import 'package:file_transfer_appplication/data/models/file_model.dart';
import 'package:file_transfer_appplication/shared/enums/file_type.dart';

void main() {
  test('DeviceModel serialization test', () {
    const device = DeviceModel(
      id: 'test_id',
      deviceName: 'Pixel 8',
      platform: 'Android',
      connectionAddress: '192.168.1.100',
      port: 8888,
    );

    final map = device.toMap();
    final restored = DeviceModel.fromMap(map);

    expect(restored.id, 'test_id');
    expect(restored.deviceName, 'Pixel 8');
    expect(restored.platform, 'Android');
    expect(restored.connectionAddress, '192.168.1.100');
  });

  test('FileModel type extension test', () {
    const file = FileModel(
      id: '1',
      name: 'photo.jpg',
      path: '/path/to/photo.jpg',
      size: 1024,
      fileType: FileType.image,
    );

    expect(file.fileType, FileType.image);
    expect(file.size, 1024);
  });
}
