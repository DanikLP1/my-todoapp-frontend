// schedule_state.dart
import 'package:equatable/equatable.dart';
import 'package:my_todo_app/models/todo_list.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ToDoList> todoLists;

  const ScheduleLoaded(this.todoLists);

  @override
  List<Object> get props => [todoLists];
}

class ScheduleUpdated extends ScheduleState {
  final List<ToDoList> todoLists;
  
  const ScheduleUpdated(this.todoLists);

  @override
  List<Object> get props => [todoLists];
}

class ScheduleError extends ScheduleState {
  final String error;

  const ScheduleError(this.error);

  @override
  List<Object> get props => [error];
}
