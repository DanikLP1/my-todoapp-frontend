import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/models/todo_list.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/repositories/schedule_repository.dart';
import 'package:uuid/uuid.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository scheduleRepository;

  ScheduleBloc({required this.scheduleRepository}) : super(ScheduleInitial()) {
    on<LoadScheduleRequested>(_onLoadScheduleRequested);
    on<AddEventRequested>(_onAddEventRequested);
    on<RemoveEventRequested>(_onRemoveEventRequested);
    on<CompleteTaskRequested>(_onCompleteTaskRequested);
    on<RefreshCacheRequested>(_onRefreshCacheRequested);
  }

  Future<void> _onLoadScheduleRequested(LoadScheduleRequested event, Emitter<ScheduleState> emit) async {
    log('LoadScheduleRequested event received');
    emit(ScheduleLoading());
    try {
      final todoLists = await scheduleRepository.fetchToDoLists();
      log('Fetched todo lists: ${todoLists.length} lists loaded');
      emit(ScheduleLoaded(todoLists));
    } catch (e) {
      log('Failed to load schedule: $e', error: e);
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onRefreshCacheRequested(RefreshCacheRequested event, Emitter<ScheduleState> emit) async {
    log('RefreshCacheRequested event received');
    emit(ScheduleLoading());
    try {
      final todoLists = await scheduleRepository.refreshCache();
      log('Fetched refreshed todo lists: ${todoLists.length} lists loaded');
      emit(ScheduleLoaded(todoLists));
    } catch (e) {
      log('Failed to refresh cache: $e', error: e);
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onAddEventRequested(AddEventRequested event, Emitter<ScheduleState> emit) async {
    if (state is ScheduleLoaded) {
      log('AddEventRequested event received');
      final newTask = Task(
        id: event.task.id,
        listId: event.task.listId,
        title: event.task.title,
        description: event.task.description,
        dueDate: event.task.dueDate,
        completed: event.task.completed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        await scheduleRepository.saveEvent(newTask);
        final todoLists = await scheduleRepository.fetchToDoLists();
        log('Fetched synced todo lists: ${todoLists.length} lists loaded');
        emit(ScheduleUpdated(todoLists));
        emit(ScheduleLoaded(todoLists));
      } catch (e) {
        log('Failed to save new task: $e', error: e);
        emit(ScheduleError(e.toString()));
      }
    } else {
      log('AddEventRequested event received but state is not ScheduleLoaded');
    }
  }

  Future<void> _onRemoveEventRequested(RemoveEventRequested event, Emitter<ScheduleState> emit) async {
    if (state is ScheduleLoaded) {
      log('RemoveEventRequested event received');
      try {
        await scheduleRepository.deleteEvent(event.listId, event.taskId);
        final todoLists = await scheduleRepository.fetchToDoLists();
        log('Fetched synced todo lists: ${todoLists.length} lists loaded');
        emit(ScheduleUpdated(todoLists));
        emit(ScheduleLoaded(todoLists));
      } catch (e) {
        log('Failed to delete task: $e', error: e);
        emit(ScheduleError(e.toString()));
      }
    } else {
      log('RemoveEventRequested event received but state is not ScheduleLoaded');
    }
  }

  Future<void> _onCompleteTaskRequested(CompleteTaskRequested event, Emitter<ScheduleState> emit) async {
    if (state is ScheduleLoaded) {
      log('CompleteTaskRequested event received');
      try {
        final completedTask = event.task.markAsCompleted();
        await scheduleRepository.updateEvent(completedTask);
        final todoLists = await scheduleRepository.fetchToDoLists();
        log('Fetched synced todo lists: ${todoLists.length} lists loaded');
        emit(ScheduleUpdated(todoLists));
        emit(ScheduleLoaded(todoLists));
      } catch (e) {
        log('Failed to update task: $e', error: e);
        emit(ScheduleError(e.toString()));
      }
    } else {
      log('CompleteTaskRequested event received but state is not ScheduleLoaded');
    }
  }
}
