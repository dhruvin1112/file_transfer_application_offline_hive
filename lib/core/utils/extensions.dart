import '../utils/app_utils.dart';
import '../../shared/enums/file_type.dart';

extension FileSizeExtension on int {
  String toReadableSize({int decimals = 2}) =>
      AppUtils.formatBytes(this, decimals: decimals);
}

extension TransferSpeedExtension on double {
  String toReadableSpeed() => AppUtils.formatSpeed(this);
}

extension StringExtension on String {
  FileType toFileType() {
    final dotIndex = lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == length - 1) return FileType.other;
    final ext = substring(dotIndex + 1);
    return FileType.fromExtension(ext);
  }

  String get fileExtension {
    final dotIndex = lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == length - 1) return '';
    return substring(dotIndex + 1).toLowerCase();
  }

  String get fileName {
    final separatorIndex = replaceAll('\\', '/').lastIndexOf('/');
    if (separatorIndex == -1) return this;
    return substring(separatorIndex + 1);
  }
}
