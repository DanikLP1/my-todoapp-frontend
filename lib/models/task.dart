import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'task.g.dart'; // Этот файл будет автоматически сгенерирован

@HiveType(typeId: 1)
class Task extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  late String listId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final DateTime? dueDate;
  @HiveField(5)
  final bool completed;
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.listId,
    required this.title,
    required this.description,
    this.dueDate,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      listId: json['listId'],
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completed: json['completed'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listId': listId,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Task markAsCompleted() {
    return Task(
      id: id,
      listId: listId,
      title: title,
      description: description,
      dueDate: dueDate,
      completed: true,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, listId, title, description, dueDate, completed, createdAt, updatedAt];
}
