import 'package:json_annotation/json_annotation.dart';

part 'customer_model.g.dart';

@JsonSerializable()
class CustomerLog {
  final String id;
  final String userId; // Staff who logged it
  final String type; // Email, Call, Visit
  final String note;
  final DateTime timestamp;

  CustomerLog({
    required this.id,
    required this.userId,
    required this.type,
    required this.note,
    required this.timestamp,
  });

  factory CustomerLog.fromJson(Map<String, dynamic> json) => _$CustomerLogFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerLogToJson(this);
}

@JsonSerializable()
class CustomerModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final Map<String, dynamic>? dynamicFields; // Custom fields defined by Admin
  final List<CustomerLog>? interactionLogs;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomerModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.dynamicFields,
    this.interactionLogs,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerModelToJson(this);
}
