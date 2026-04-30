class Contact {
  final String name;
  final String phone;
  final String email;
  final String relationship;
  final bool isPrimary;
  final bool isVerified;

  Contact({
    required this.name,
    required this.phone,
    required this.email,
    required this.relationship,
    this.isPrimary = false,
    this.isVerified = false,
  });

  bool get isOwner => relationship.toLowerCase() == 'owner';

  String get relationshipLabel {
    switch (relationship.toLowerCase()) {
      case 'owner':
        return 'Property Owner';
      default:
        return relationship
            .split(RegExp(r'[ _-]+'))
            .map(
              (word) => word.isEmpty
                  ? word
                  : word[0].toUpperCase() + word.substring(1).toLowerCase(),
            )
            .join(' ');
    }
  }

  // Factory constructors
  factory Contact.owner({
    required String name,
    required String phone,
    required String email,
    bool isVerified = false,
  }) {
    return Contact(
      name: name,
      phone: phone,
      email: email,
      relationship: 'owner',
      isPrimary: true,
      isVerified: isVerified,
    );
  }

  factory Contact.reference({
    required String name,
    required String phone,
    required String email,
    required String relationship,
  }) {
    return Contact(
      name: name,
      phone: phone,
      email: email,
      relationship: relationship,
      isPrimary: false,
      isVerified: false,
    );
  }

  // JSON serialization for API
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      relationship: json['relationship'] ?? '',
      isPrimary: json['isPrimary'] ?? json['is_primary'] ?? false,
      isVerified: json['isVerified'] ?? json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'relationship': relationship,
      'isPrimary': isPrimary,
      'isVerified': isVerified,
    };
  }
}
