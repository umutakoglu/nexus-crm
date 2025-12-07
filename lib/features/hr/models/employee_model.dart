import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String role; // Admin, Manager, Staff
  final String department;
  final String iban;
  final DateTime startDate;
  final int remainingLeaveDays;
  final String? managerId;
  final String? managerName;

  EmployeeModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    required this.iban,
    required this.startDate,
    required this.remainingLeaveDays,
    this.managerId,
    this.managerName,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'department': department,
      'iban': iban,
      'startDate': Timestamp.fromDate(startDate),
      'remainingLeaveDays': remainingLeaveDays,
      'managerId': managerId,
      'managerName': managerName,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map, String id) {
    return EmployeeModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'Staff',
      department: map['department'] ?? '',
      iban: map['iban'] ?? '',
      startDate: (map['startDate'] as Timestamp).toDate(),
      remainingLeaveDays: map['remainingLeaveDays'] ?? 14,
      managerId: map['managerId'],
      managerName: map['managerName'],
    );
  }
}
