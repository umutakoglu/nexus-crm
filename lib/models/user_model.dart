import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum UserRole {
  admin,
  hrManager,
  unitManager,
  fieldStaff,
  standardEmployee,
}

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String displayName;
  final UserRole role;
  final String? parentId; // Manager ID
  final String? photoUrl;
  final String? department;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    this.parentId,
    this.photoUrl,
    this.department,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
