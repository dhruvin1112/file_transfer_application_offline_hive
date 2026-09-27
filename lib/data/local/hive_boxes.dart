import 'package:hive/hive.dart';
import '../../core/constants/storage_keys.dart';

class HiveBoxes {
  HiveBoxes._();

  static Box<Map>? _historyBox;
  static Box<Map>? _metadataBox;

  static Box<Map> get historyBox {
    if (_historyBox == null || !_historyBox!.isOpen) {
      throw StateError('History Box is not open. Ensure HiveService.init() was called.');
    }
    return _historyBox!;
  }

  static Box<Map> get metadataBox {
    if (_metadataBox == null || !_metadataBox!.isOpen) {
      throw StateError('Metadata Box is not open. Ensure HiveService.init() was called.');
    }
    return _metadataBox!;
  }

  static Future<void> openBoxes() async {
    _historyBox = await Hive.openBox<Map>(StorageKeys.transferHistoryBox);
    _metadataBox = await Hive.openBox<Map>(StorageKeys.transferMetadataBox);
  }

  static Future<void> closeBoxes() async {
    await _historyBox?.close();
    await _metadataBox?.close();
  }
}
