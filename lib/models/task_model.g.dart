// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  assignedToId: json['assignedToId'] as String,
  createdById: json['createdById'] as String,
  status: $enumDecode(_$TaskStatusEnumMap, json['status']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  dueDate: DateTime.parse(json['dueDate'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  dynamicFields: json['dynamicFields'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'assignedToId': instance.assignedToId,
  'createdById': instance.createdById,
  'status': _$TaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'dueDate': instance.dueDate.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'dynamicFields': instance.dynamicFields,
};

const _$TaskStatusEnumMap = {
  TaskStatus.todo: 'todo',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.completed: 'completed',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
  TaskPriority.urgent: 'urgent',
};
