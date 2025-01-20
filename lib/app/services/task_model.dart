import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String? dueDate;

  @HiveField(2)
  final String priority;

  @HiveField(3)
  bool isCompleted;

  TaskModel({required this.name, this.dueDate, required this.priority,this.isCompleted = false});
}
