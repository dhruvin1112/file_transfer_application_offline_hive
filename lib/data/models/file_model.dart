import '../../shared/enums/file_type.dart';

class FileModel {
  final String id;
  final String name;
  final String path;
  final int size;
  final FileType fileType;
  final String? checksum;
  final String? mimeType;
  final bool isSelected;

  const FileModel({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.fileType,
    this.checksum,
    this.mimeType,
    this.isSelected = false,
  });

  FileModel copyWith({
    String? id,
    String? name,
    String? path,
    int? size,
    FileType? fileType,
    String? checksum,
    String? mimeType,
    bool? isSelected,
  }) {
    return FileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      size: size ?? this.size,
      fileType: fileType ?? this.fileType,
      checksum: checksum ?? this.checksum,
      mimeType: mimeType ?? this.mimeType,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'size': size,
      'fileType': fileType.name,
      'checksum': checksum,
      'mimeType': mimeType,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      path: map['path'] as String? ?? '',
      size: map['size'] as int? ?? 0,
      fileType: FileType.values.firstWhere(
        (e) => e.name == map['fileType'],
        orElse: () => FileType.other,
      ),
      checksum: map['checksum'] as String?,
      mimeType: map['mimeType'] as String?,
    );
  }

  @override
  String toString() => 'FileModel(id: $id, name: $name, size: $size, type: $fileType)';
}
