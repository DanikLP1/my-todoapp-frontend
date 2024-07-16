// auth_repository.dart
import 'package:my_todo_app/models/tokens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository({required this.apiService});

  Future<void> login(String email, String password) async {
    final response = await apiService.post('/auth/local/signin', data: {'email': email, 'password': password});
    final token = AuthToken.fromJson(response.data);
    await apiService.saveTokensToStorage(token.accessToken, token.refreshToken);
  }

  Future<void> register(String username, String email, String password) async {
    final response = await apiService.post('/auth/local/signup', data: {'username': username, 'email': email, 'password': password});
    final token = AuthToken.fromJson(response.data);
    await apiService.saveTokensToStorage(token.accessToken, token.refreshToken);
  }

  Future<void> logout() async {
    try {
      final token = await apiService.getTokensFromStorage();
      if (token != null) {
        await apiService.post('/auth/logout');
      }
    } catch (e) {
      print('Error during logout: $e');
    }
    await apiService.clearTokens();
  }

}
