import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveRequestModel {
  final String? id;
  final String employeeId;
  final String employeeName;
  final String type; // Yıllık, Hastalık, Mazeret
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String status; // Pending, Approved, Rejected
  final String? managerId;

  LeaveRequestModel({
    this.id,
    required this.employeeId,
    required this.employeeName,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.description,
    this.status = 'Pending',
    this.managerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'type': type,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'description': description,
      'status': status,
      'managerId': managerId,
    };
  }

  factory LeaveRequestModel.fromMap(Map<String, dynamic> map, String id) {
    return LeaveRequestModel(
      id: id,
      employeeId: map['employeeId'] ?? '',
      employeeName: map['employeeName'] ?? '',
      type: map['type'] ?? 'Yıllık',
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      description: map['description'] ?? '',
      status: map['status'] ?? 'Pending',
      managerId: map['managerId'],
    );
  }

  int get durationInDays {
    return endDate.difference(startDate).inDays + 1;
  }
}
