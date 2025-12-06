// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerLog _$CustomerLogFromJson(Map<String, dynamic> json) => CustomerLog(
  id: json['id'] as String,
  userId: json['userId'] as String,
  type: json['type'] as String,
  note: json['note'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$CustomerLogToJson(CustomerLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'note': instance.note,
      'timestamp': instance.timestamp.toIso8601String(),
    };

CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) =>
    CustomerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      dynamicFields: json['dynamicFields'] as Map<String, dynamic>?,
      interactionLogs: (json['interactionLogs'] as List<dynamic>?)
          ?.map((e) => CustomerLog.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CustomerModelToJson(CustomerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'dynamicFields': instance.dynamicFields,
      'interactionLogs': instance.interactionLogs,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
