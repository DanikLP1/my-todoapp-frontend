import 'package:equatable/equatable.dart';
import 'package:my_todo_app/models/task.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class LoadScheduleRequested extends ScheduleEvent {}

class AddEventRequested extends ScheduleEvent {
  final Task task;

  AddEventRequested(this.task);

  @override
  List<Object> get props => [task];
}

class RemoveEventRequested extends ScheduleEvent {
  final int listId;
  final int taskId;

  RemoveEventRequested(this.listId, this.taskId);

  @override
  List<Object> get props => [listId, taskId];
}

class CompleteTaskRequested extends ScheduleEvent {
  final Task task;

  CompleteTaskRequested(this.task);

  @override
  List<Object> get props => [task];
}