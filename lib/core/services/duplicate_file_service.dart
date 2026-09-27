import 'dart:io';
import '../../data/models/file_model.dart';
import '../utils/app_utils.dart';

class DuplicateGroup {
  final String checksum;
  final int fileSize;
  final List<FileModel> files;

  DuplicateGroup({
    required this.checksum,
    required this.fileSize,
    required this.files,
  });
}

class DuplicateFileService {
  /// Scans a list of FileModels and groups duplicate files
  Future<List<DuplicateGroup>> findDuplicates(List<FileModel> candidateFiles) async {
    if (candidateFiles.length < 2) return [];

    // Step 1: Bucket by exact file size
    final Map<int, List<FileModel>> sizeBuckets = {};
    for (final file in candidateFiles) {
      if (file.size > 0) {
        sizeBuckets.putIfAbsent(file.size, () => []).add(file);
      }
    }

    final List<DuplicateGroup> duplicateGroups = [];

    // Step 2: For any bucket with >= 2 files, compute SHA-256
    for (final entry in sizeBuckets.entries) {
      final bucketFiles = entry.value;
      if (bucketFiles.length < 2) continue;

      final Map<String, List<FileModel>> hashBuckets = {};

      for (final fileModel in bucketFiles) {
        try {
          final file = File(fileModel.path);
          if (await file.exists()) {
            final hash = await AppUtils.calculateSha256(file.path);
            hashBuckets.putIfAbsent(hash, () => []).add(fileModel);
          }
        } catch (_) {
          // Skip inaccessible file
        }
      }

      for (final hashEntry in hashBuckets.entries) {
        if (hashEntry.value.length > 1) {
          duplicateGroups.add(
            DuplicateGroup(
              checksum: hashEntry.key,
              fileSize: entry.key,
              files: hashEntry.value,
            ),
          );
        }
      }
    }

    return duplicateGroups;
  }
}
