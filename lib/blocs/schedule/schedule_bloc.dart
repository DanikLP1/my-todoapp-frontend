// schedule_bloc.dart
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
      final currentState = state as ScheduleLoaded;
      try {
        final task = Task(
          id: 0, // ID создается автоматически на сервере
          listId: event.task.listId,
          title: event.task.title,
          description: event.task.description,
          dueDate: event.task.dueDate,
          completed: event.task.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await scheduleRepository.saveEvent(task);

        // Обновление состояния
        final updatedLists = currentState.todoLists.map((list) {
          if (list.id == task.listId) {
            return list.copyWith(tasks: List.from(list.tasks)..add(task));
          }
          return list;
        }).toList();
        emit(ScheduleLoaded(updatedLists));
      } catch (e) {
        emit(ScheduleError(e.toString()));
      }
    }
  }

  Future<void> _onRemoveEventRequested(RemoveEventRequested event, Emitter<ScheduleState> emit) async {
    if (state is ScheduleLoaded) {
      final currentState = state as ScheduleLoaded;
      try {
        await scheduleRepository.deleteEvent(event.listId, event.taskId);

        // Обновление состояния
        final updatedLists = currentState.todoLists.map((list) {
          if (list.id == event.listId) {
            return list.copyWith(
              tasks: list.tasks.where((task) => task.id != event.taskId).toList(),
            );
          }
          return list;
        }).toList();
        emit(ScheduleLoaded(updatedLists));
      } catch (e) {
        emit(ScheduleError(e.toString()));
      }
    }
  }
}
