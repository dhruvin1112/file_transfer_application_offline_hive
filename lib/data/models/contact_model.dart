class ContactModel {
  final String id;
  final String name;
  final List<String> phoneNumbers;
  final List<String> emailAddresses;
  final bool isSelected;

  const ContactModel({
    required this.id,
    required this.name,
    this.phoneNumbers = const [],
    this.emailAddresses = const [],
    this.isSelected = false,
  });

  ContactModel copyWith({
    String? id,
    String? name,
    List<String>? phoneNumbers,
    List<String>? emailAddresses,
    bool? isSelected,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      emailAddresses: emailAddresses ?? this.emailAddresses,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumbers': phoneNumbers,
      'emailAddresses': emailAddresses,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      phoneNumbers: List<String>.from(map['phoneNumbers'] as List? ?? []),
      emailAddresses: List<String>.from(map['emailAddresses'] as List? ?? []),
    );
  }

  /// Converts this contact to a standard vCard (VCF) format for cross-platform portability
  String toVCard() {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');
    buffer.writeln('FN:$name');
    for (final phone in phoneNumbers) {
      buffer.writeln('TEL;TYPE=CELL:$phone');
    }
    for (final email in emailAddresses) {
      buffer.writeln('EMAIL;TYPE=INTERNET:$email');
    }
    buffer.writeln('END:VCARD');
    return buffer.toString();
  }
}
