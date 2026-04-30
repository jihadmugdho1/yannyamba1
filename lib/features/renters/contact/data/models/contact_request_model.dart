class ContactRequest {
  final String subject;
  final String description;
  final String? attachmentPath;
  final DateTime createdAt;

  ContactRequest({
    required this.subject,
    required this.description,
    this.attachmentPath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get hasAttachment =>
      attachmentPath != null && attachmentPath!.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'description': description,
      'attachmentPath': attachmentPath,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
