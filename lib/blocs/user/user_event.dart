import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUserRequested extends UserEvent {}

class UpdateUserRequested extends UserEvent {
  final String name;
  final String email;

  const UpdateUserRequested({required this.name, required this.email});

  @override
  List<Object> get props => [name, email];
}