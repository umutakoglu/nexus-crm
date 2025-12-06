// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveRequestModel _$LeaveRequestModelFromJson(Map<String, dynamic> json) =>
    LeaveRequestModel(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      type: $enumDecode(_$LeaveTypeEnumMap, json['type']),
      status: $enumDecode(_$LeaveStatusEnumMap, json['status']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      reason: json['reason'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      attachmentUrl: json['attachmentUrl'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$LeaveRequestModelToJson(LeaveRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'type': _$LeaveTypeEnumMap[instance.type]!,
      'status': _$LeaveStatusEnumMap[instance.status]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'reason': instance.reason,
      'amount': instance.amount,
      'attachmentUrl': instance.attachmentUrl,
      'rejectionReason': instance.rejectionReason,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$LeaveTypeEnumMap = {
  LeaveType.annual: 'annual',
  LeaveType.sick: 'sick',
  LeaveType.unpaid: 'unpaid',
  LeaveType.expense: 'expense',
};

const _$LeaveStatusEnumMap = {
  LeaveStatus.pending: 'pending',
  LeaveStatus.approved: 'approved',
  LeaveStatus.rejected: 'rejected',
};
