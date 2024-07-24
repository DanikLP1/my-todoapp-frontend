import 'dart:developer';

import 'package:my_todo_app/models/todo_list.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/utils/hive_service.dart';
import 'package:uuid/uuid.dart';

import '../utils/api_service.dart';

class ScheduleRepository {
  final ApiService apiService;
  final HiveService hiveService;

  ScheduleRepository({required this.apiService, required this.hiveService});

  Future<List<ToDoList>> fetchToDoLists() async {
    try {
      final cachedLists = hiveService.getToDoLists();
      if (cachedLists.isNotEmpty) {
        return cachedLists;
      }

      final response = await apiService.get('/todolists');
      List<dynamic> data = response.data;
      final todoLists = data.map((json) => ToDoList.fromJson(json)).toList();

      for (var list in todoLists) {
        hiveService.addToDoList(list);
      }

      return todoLists;
    } catch (e) {
      throw Exception('Failed to load to-do lists: $e');
    }
  }

  Future<void> saveEvent(Task task) async {
  try {
    final lists = hiveService.getToDoLists();
    
    // Получаем сегодняшнюю дату без времени
    final taskDay = task.dueDate;
    final taskDateOnly = DateTime(taskDay!.year, taskDay.month, taskDay.day).toUtc();

    // Ищем список дел, соответствующий сегодняшнему дню
    final listIndex = lists.indexWhere((list) {
      final listDate = list.date;
      if (listDate == null) return false;
      final listDateOnly = DateTime(listDate.year, listDate.month, listDate.day).toUtc();
      log(taskDateOnly.toString());
      log(listDateOnly.toString());
      return listDateOnly == taskDateOnly;
    });

    if (listIndex == -1) {
      // Создаем новый список дел, если его нет
      final newToDoList = ToDoList(
        id: task.listId,
        userId: '', // используйте актуальный userId
        title: 'Список дел на ${task.dueDate?.toLocal().toIso8601String().split('T')[0]}',
        date: task.dueDate,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
        tasks: [task],
      );

      await apiService.post('/todolists', data: newToDoList.toJson());
      hiveService.addToDoList(newToDoList);
    } else {
      // Добавляем задачу в существующий список дел
      lists[listIndex].tasks.add(task);
      await apiService.post('/todolists/${lists[listIndex].id}/tasks', data: task.toJson());
      hiveService.updateTask(task);
    }

    hiveService.logToDoLists();
  } catch (e) {
    throw Exception('Failed to save event: $e');
  }
}

  Future<void> updateEvent(Task task) async {
    try {
      await apiService.put('/todolists/${task.listId}/tasks/${task.id}', data: task.toJson());
      hiveService.updateTask(task);
      hiveService.logToDoLists();
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  Future<void> deleteEvent(String listId, String taskId) async {
    try {
      await apiService.delete('/todolists/$listId/tasks/$taskId');
      hiveService.deleteTask(listId, taskId);
      hiveService.logToDoLists();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  Future<List<ToDoList>> refreshCache() async {
    try {
      // Очищаем кэш
      hiveService.clearCache();

      // Получаем данные с бэкенда
      final response = await apiService.get('/todolists');
      List<dynamic> data = response.data;
      final todoLists = data.map((json) => ToDoList.fromJson(json)).toList();

      // Кэшируем данные
      for (var list in todoLists) {
        hiveService.addToDoList(list);
      }

      log('Cache refreshed successfully');
      return todoLists;
    } catch (e) {
      throw Exception('Failed to refresh cache: $e');
    }
  }
}

