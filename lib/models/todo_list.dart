import 'package:equatable/equatable.dart';
import 'task.dart';

class ToDoList extends Equatable {
  final int id;
  final int userId;
  final String title;
  final DateTime? date;
  final DateTime createdAt;
  final DateTime updatedAt;
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
    int? id,
    int? userId,
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