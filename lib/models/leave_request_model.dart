import 'package:json_annotation/json_annotation.dart';

part 'leave_request_model.g.dart';

enum LeaveType {
  annual,
  sick,
  unpaid,
  expense, // Used for expense reports
}

enum LeaveStatus {
  pending,
  approved,
  rejected,
}

@JsonSerializable()
class LeaveRequestModel {
  final String id;
  final String employeeId;
  final LeaveType type;
  final LeaveStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final double? amount; // For expense reports
  final String? attachmentUrl; // Receipt or doc
  final String? rejectionReason;
  final DateTime createdAt;

  LeaveRequestModel({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.amount,
    this.attachmentUrl,
    this.rejectionReason,
    required this.createdAt,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) => _$LeaveRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$LeaveRequestModelToJson(this);
}
