// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  parentId: json['parentId'] as String?,
  photoUrl: json['photoUrl'] as String?,
  department: json['department'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'displayName': instance.displayName,
  'role': _$UserRoleEnumMap[instance.role]!,
  'parentId': instance.parentId,
  'photoUrl': instance.photoUrl,
  'department': instance.department,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.hrManager: 'hrManager',
  UserRole.unitManager: 'unitManager',
  UserRole.fieldStaff: 'fieldStaff',
  UserRole.standardEmployee: 'standardEmployee',
};
