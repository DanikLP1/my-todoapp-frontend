// repositories/schedule_repository.dart
import 'package:my_todo_app/models/todo_list.dart';
import 'package:my_todo_app/models/task.dart';

import 'api_service.dart';

class ScheduleRepository {
  final ApiService apiService;

  ScheduleRepository({required this.apiService});

  Future<List<ToDoList>> fetchToDoLists() async {
    try {
      final response = await apiService.get('/todolists');
      List<dynamic> data = response.data;
      return data.map((json) => ToDoList.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load to-do lists: $e');
    }
  }

  Future<void> saveEvent(Task task) async {
    try {
      await apiService.post('/todolists/${task.listId}/tasks', data: task.toJson());
    } catch (e) {
      throw Exception('Failed to save event: $e');
    }
  }

  Future<void> deleteEvent(int listId, int taskId) async {
    try {
      await apiService.delete('/todolists/$listId/tasks/$taskId');
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}
