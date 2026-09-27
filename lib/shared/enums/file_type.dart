enum FileType {
  image,
  video,
  audio,
  document,
  application,
  contact,
  other;

  String get displayName {
    switch (this) {
      case FileType.image:
        return 'Photos & Images';
      case FileType.video:
        return 'Videos';
      case FileType.audio:
        return 'Music & Audio';
      case FileType.document:
        return 'Documents';
      case FileType.application:
        return 'Applications';
      case FileType.contact:
        return 'Contacts';
      case FileType.other:
        return 'Other Files';
    }
  }

  static FileType fromExtension(String extension) {
    final ext = extension.toLowerCase().replaceAll('.', '');
    switch (ext) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
      case 'heic':
      case 'bmp':
      case 'svg':
        return FileType.image;
      case 'mp4':
      case 'mkv':
      case 'mov':
      case 'avi':
      case 'flv':
      case 'webm':
      case '3gp':
        return FileType.video;
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'm4a':
      case 'flac':
      case 'ogg':
      case 'wma':
        return FileType.audio;
      case 'pdf':
      case 'doc':
      case 'docx':
      case 'xls':
      case 'xlsx':
      case 'ppt':
      case 'pptx':
      case 'txt':
      case 'csv':
        return FileType.document;
      case 'apk':
      case 'ipa':
        return FileType.application;
      case 'vcf':
        return FileType.contact;
      default:
        return FileType.other;
    }
  }
}
