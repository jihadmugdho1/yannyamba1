import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:yannyamba/core/core.dart';

class ReferenceModel {
  final String name;
  final String phoneNumber;
  final String relationship;

  ReferenceModel({
    required this.name,
    required this.phoneNumber,
    required this.relationship,
  });

  Map<String, dynamic> toJson() {
    return {
      'reference_name': name,
      'reference_phone': phoneNumber,
      'reference_relationship': relationship,
    };
  }

  factory ReferenceModel.fromJson(Map<String, dynamic> json) {
    return ReferenceModel(
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      relationship: json['relationship'] as String,
    );
  }

  ReferenceModel copyWith({
    String? name,
    String? phoneNumber,
    String? relationship,
  }) {
    return ReferenceModel(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      relationship: relationship ?? this.relationship,
    );
  }
}

// Common relationship types
class RelationshipTypes {
  static String get neighbour => AppText.neighbour.tr;
  static String get previousTenant => AppText.previousTenant.tr;
  static String get localContact => AppText.localContact.tr;
  static String get friend => AppText.friend.tr;
  static String get relative => AppText.relative.tr;
  static String get caretaker => AppText.caretaker.tr;
  static String get societyMember => AppText.societyMember.tr;
  static String get other => AppText.other.tr;

  static List<String> get all => [
    neighbour,
    previousTenant,
    localContact,
    friend,
    relative,
    caretaker,
    societyMember,
    other,
  ];
}
