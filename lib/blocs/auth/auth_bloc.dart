// auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/api_service.dart';
import '../../repositories/auth_repository.dart';
import '../user/bloc.dart';
import 'bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final UserBloc userBloc;
  final ApiService apiService;

  AuthBloc({required this.authRepository, required this.userBloc, required this.apiService}) : super(AuthInitial()) {
    _checkAuthenticationStatus();
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _checkAuthenticationStatus() async {
    final token = await apiService.getTokensFromStorage();
    if (token != null) {
      apiService.setTokens(token.accessToken, token.refreshToken);
      emit(AuthAuthenticated(token: token));
      userBloc.add(LoadUserRequested());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.login(event.email, event.password);
      final token = await apiService.getTokensFromStorage();
      if (token != null) {
        apiService.setTokens(token.accessToken, token.refreshToken);
        emit(AuthAuthenticated(token: token));
        userBloc.add(LoadUserRequested());
      } else {
        emit(AuthFailure(error: 'Failed to retrieve tokens after login'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.register(event.username, event.email, event.password);
      final token = await apiService.getTokensFromStorage();
      if (token != null) {
        apiService.setTokens(token.accessToken, token.refreshToken);
        emit(AuthAuthenticated(token: token));
        userBloc.add(LoadUserRequested());
      } else {
        emit(AuthFailure(error: 'Failed to retrieve tokens after registration'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    try {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
