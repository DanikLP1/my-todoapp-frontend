import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/models/todo_list.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/repositories/schedule_repository.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository scheduleRepository;

  ScheduleBloc({required this.scheduleRepository}) : super(ScheduleInitial()) {
    on<LoadScheduleRequested>(_onLoadScheduleRequested);
    on<AddEventRequested>(_onAddEventRequested);
    on<RemoveEventRequested>(_onRemoveEventRequested);
    on<CompleteTaskRequested>(_onCompleteTaskRequested);
  }

  Future<void> _onLoadScheduleRequested(LoadScheduleRequested event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      final todoLists = await scheduleRepository.fetchToDoLists();
      emit(ScheduleLoaded(todoLists));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onAddEventRequested(AddEventRequested event, Emitter<ScheduleState> emit) async {
    if (state is ScheduleLoaded) {
      // Оптимистичное обновление состояния
      final currentState = state as ScheduleLoaded;
      final updatedTodoLists = List<ToDoList>.from(currentState.todoLists);

      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch, // Временный ID для локального состояния
        listId: event.task.listId,
        title: event.task.title,
        description: event.task.description,
        dueDate: event.task.dueDate,
        completed: event.task.completed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final listIndex = updatedTodoLists.indexWhere((list) => list.id == event.task.listId);
      if (listIndex != -1) {
        updatedTodoLists[listIndex].tasks.add(newTask);
      }

      emit(ScheduleLoaded(updatedTodoLists));

      try {
        // Отправка данных на сервер
        await scheduleRepository.saveEvent(newTask);
        // Синхронизация с сервером
        final syncedTodoLists = await scheduleRepository.fetchToDoLists();
        emit(ScheduleLoaded(syncedTodoLists));
      } catch (e) {
        emit(ScheduleError(e.toString()));
      }
    }
  }

  Future<void> _onRemoveEventRequested(RemoveEventRequested event, Emitter<ScheduleState> emit) async {
    if (state is ScheduleLoaded) {
      // Оптимистичное обновление состояния
      final currentState = state as ScheduleLoaded;
      final updatedTodoLists = List<ToDoList>.from(currentState.todoLists);

      final listIndex = updatedTodoLists.indexWhere((list) => list.id == event.listId);
      if (listIndex != -1) {
        updatedTodoLists[listIndex].tasks.removeWhere((task) => task.id == event.taskId);
      }

      emit(ScheduleLoaded(updatedTodoLists));

      try {
        // Отправка данных на сервер
        await scheduleRepository.deleteEvent(event.listId, event.taskId);
        // Синхронизация с сервером
        final syncedTodoLists = await scheduleRepository.fetchToDoLists();
        emit(ScheduleLoaded(syncedTodoLists));
      } catch (e) {
        emit(ScheduleError(e.toString()));
      }
    }
  }

  Future<void> _onCompleteTaskRequested(CompleteTaskRequested event, Emitter<ScheduleState> emit) async {
    if (state is ScheduleLoaded) {
      // Оптимистичное обновление состояния
      final currentState = state as ScheduleLoaded;
      final updatedTodoLists = List<ToDoList>.from(currentState.todoLists);

      final listIndex = updatedTodoLists.indexWhere((list) => list.id == event.task.listId);
      if (listIndex != -1) {
        final taskIndex = updatedTodoLists[listIndex].tasks.indexWhere((task) => task.id == event.task.id);
        if (taskIndex != -1) {
          final updatedTask = event.task.markAsCompleted();
          updatedTodoLists[listIndex].tasks[taskIndex] = updatedTask;
        }
      }

      emit(ScheduleLoaded(updatedTodoLists));

      try {
        // Отправка данных на сервер
        final completedTask = event.task.markAsCompleted();
        await scheduleRepository.updateEvent(completedTask);
        // Синхронизация с сервером
        final syncedTodoLists = await scheduleRepository.fetchToDoLists();
        emit(ScheduleLoaded(syncedTodoLists));
      } catch (e) {
        emit(ScheduleError(e.toString()));
      }
    }
  }
}
