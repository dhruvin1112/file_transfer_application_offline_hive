import 'dart:io';
import 'package:file_picker/file_picker.dart' as fp;
import '../../core/services/duplicate_file_service.dart';
import '../../core/services/permission_service.dart';
import '../../shared/enums/file_type.dart';
import '../models/file_model.dart';

class FileRepository {
  final PermissionService permissionService;
  final DuplicateFileService duplicateFileService;

  FileRepository({
    required this.permissionService,
    required this.duplicateFileService,
  });

  /// Picks files from device storage according to requested FileType
  Future<List<FileModel>> pickFiles({FileType? type}) async {
    final hasPermission = await permissionService.requestStoragePermissions();
    if (!hasPermission) return [];

    fp.FileType pickerType = fp.FileType.any;
    if (type == FileType.image) {
      pickerType = fp.FileType.image;
    } else if (type == FileType.video) {
      pickerType = fp.FileType.video;
    } else if (type == FileType.audio) {
      pickerType = fp.FileType.audio;
    }

    final result = await fp.FilePicker.pickFiles(
      type: pickerType,
    );

    if (result.isEmpty) return [];

    final List<FileModel> files = [];
    for (final picked in result) {
      if (picked.path != null) {
        final f = File(picked.path!);
        final size = picked.lengthSync() ?? (await f.length());
        final name = picked.name;
        final detectedType = type ?? FileType.fromExtension(name.split('.').last);

        files.add(
          FileModel(
            id: picked.path!,
            name: name,
            path: picked.path!,
            size: size > 0 ? size : (await f.length()),
            fileType: detectedType,
            isSelected: true,
          ),
        );
      }
    }
    return files;
  }

  /// Scans candidates and groups duplicates
  Future<List<DuplicateGroup>> scanDuplicates(List<FileModel> candidateFiles) =>
      duplicateFileService.findDuplicates(candidateFiles);
}
