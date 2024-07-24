import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/models/todo_list.dart';

class HiveService {
  final Box<ToDoList> _todoListBox = Hive.box<ToDoList>('todoListBox');

  Future<void> addToDoList(ToDoList todoList) async {
    await _todoListBox.put(todoList.id, todoList);
    logToDoLists();
  }

  List<ToDoList> getToDoLists() {
    return _todoListBox.values.toList();
  }

  Future<void> updateTask(Task task) async {
    final lists = getToDoLists();
    final listIndex = lists.indexWhere((list) => list.id == task.listId);
    if (listIndex != -1) {
      final taskIndex = lists[listIndex].tasks.indexWhere((t) => t.id == task.id);
      if (taskIndex != -1) {
        lists[listIndex].tasks[taskIndex] = task;
      } else {
        lists[listIndex].tasks.add(task);
      }
      await addToDoList(lists[listIndex]);
    }
  }

  Future<void> deleteTask(String listId, String taskId) async {
    final lists = getToDoLists();
    final listIndex = lists.indexWhere((list) => list.id == listId);
    if (listIndex != -1) {
      lists[listIndex].tasks.removeWhere((task) => task.id == taskId);
      await addToDoList(lists[listIndex]);
    }
  }

  Future<void> clearCache() async {
    await _todoListBox.clear();
    log('Cache cleared');
  }

  void logToDoLists() {
    final lists = getToDoLists();
    log('Current ToDoLists: ${lists.length}');
    for (var list in lists) {
      log('ToDoList ID: ${list.id}, Title: ${list.title}, Tasks: ${list.tasks.length}');
      for (var task in list.tasks) {
        log('  Task ID: ${task.id}, Title: ${task.title}, Completed: ${task.completed}');
      }
    }
  }
}
