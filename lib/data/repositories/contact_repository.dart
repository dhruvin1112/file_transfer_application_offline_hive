import '../../core/services/contact_service.dart';
import '../models/contact_model.dart';
import '../models/file_model.dart';

class ContactRepository {
  final ContactService _contactService;

  ContactRepository(this._contactService);

  /// Fetches contacts supported by platform permissions
  Future<List<ContactModel>> getContacts() => _contactService.getContacts();

  /// Exports selected contacts to a vCard (.vcf) file ready for transfer
  Future<FileModel?> exportContactsToVcf(List<ContactModel> contacts) =>
      _contactService.exportContactsToVcf(contacts);
}
