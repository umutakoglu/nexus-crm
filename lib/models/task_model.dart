import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

enum TaskStatus {
  todo,
  inProgress,
  completed,
}

enum TaskPriority {
  low,
  medium,
  high,
  urgent,
}

@JsonSerializable()
class TaskModel {
  final String id;
  final String title;
  final String description;
  final String assignedToId; // Employee ID
  final String createdById; // Manager ID
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime dueDate;
  final DateTime createdAt;
  final Map<String, dynamic>? dynamicFields;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedToId,
    required this.createdById,
    required this.status,
    required this.priority,
    required this.dueDate,
    required this.createdAt,
    this.dynamicFields,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}
