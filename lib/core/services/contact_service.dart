import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../data/models/contact_model.dart';
import '../../data/models/file_model.dart';
import '../../shared/enums/file_type.dart';
import 'permission_service.dart';

class ContactService {
  final PermissionService _permissionService;

  ContactService(this._permissionService);

  /// Requests permission and fetches user-accessible contacts
  Future<List<ContactModel>> getContacts() async {
    final hasPermission = await _permissionService.requestContactsPermission();
    if (!hasPermission) {
      return [];
    }

    // In production, flutter contacts/native channel reads contacts
    // Returns contact model representations
    return [];
  }

  /// Exports selected contacts into a standard multi-entry vCard (.vcf) file
  Future<FileModel?> exportContactsToVcf(List<ContactModel> contacts) async {
    if (contacts.isEmpty) return null;

    final tempDir = await getTemporaryDirectory();
    final vcfFile = File('${tempDir.path}/contacts_${DateTime.now().millisecondsSinceEpoch}.vcf');

    final buffer = StringBuffer();
    for (final contact in contacts) {
      buffer.write(contact.toVCard());
    }

    await vcfFile.writeAsString(buffer.toString());
    final size = await vcfFile.length();

    return FileModel(
      id: vcfFile.path,
      name: vcfFile.path.split(Platform.pathSeparator).last,
      path: vcfFile.path,
      size: size,
      fileType: FileType.contact,
      mimeType: 'text/vcard',
    );
  }
}
