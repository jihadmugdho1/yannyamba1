class Profile {
  const Profile({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.imageUrl,
    required this.roles,
  });

  final String name;
  final String phoneNumber;
  final String email;
  final String imageUrl;
  final List<String> roles;

  // Convenience getters
  bool get isOwner => roles.contains('OWNER');
  bool get isRenter => roles.contains('RENTER');

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['data']['name'] as String? ?? '',
      phoneNumber: json['data']['phone'] as String? ?? '',
      email: json['data']['email'] as String? ?? '',
      imageUrl: json['data']['photo'] as String? ?? '',
      roles:
          (json['data']['roles'] as List<dynamic>?)
              ?.map((role) => role.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phoneNumber,
      'email': email,
      'photo': imageUrl,
      'roles': roles,
    };
  }

  Profile copyWith({
    String? name,
    String? phoneNumber,
    String? email,
    String? imageUrl,
    List<String>? roles,
  }) {
    return Profile(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      roles: roles ?? this.roles,
    );
  }
}
