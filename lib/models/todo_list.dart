import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'task.dart';

part 'todo_list.g.dart'; // Этот файл будет автоматически сгенерирован

@HiveType(typeId: 0)
class ToDoList extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final DateTime? date;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final DateTime updatedAt;
  @HiveField(6)
  final List<Task> tasks;

  ToDoList({
    required this.id,
    required this.userId,
    required this.title,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.tasks = const [],
  });

  factory ToDoList.fromJson(Map<String, dynamic> json) {
    var tasksFromJson = json['tasks'] as List? ?? [];
    List<Task> taskList = tasksFromJson.map((taskJson) => Task.fromJson(taskJson)).toList();
    return ToDoList(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      tasks: taskList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'date': date?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  ToDoList copyWith({
    String? id,
    String? userId,
    String? title,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Task>? tasks,
  }) {
    return ToDoList(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [id, userId, title, date, createdAt, updatedAt, tasks];
}
