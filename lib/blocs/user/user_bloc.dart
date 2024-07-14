import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/user_repository.dart';
import 'bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoadUserRequested>(_onLoadUserRequested);
    on<UpdateUserRequested>(_onUpdateUserRequested);
  }

  Future<void> _onLoadUserRequested(LoadUserRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await userRepository.getUser();
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(error: e.toString()));
    }
  }

  Future<void> _onUpdateUserRequested(UpdateUserRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await userRepository.updateUser(event.name, event.email);
      final user = await userRepository.getUser();
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(error: e.toString()));
    }
  }
}