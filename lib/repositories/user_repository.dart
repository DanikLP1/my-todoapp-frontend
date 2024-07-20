

import 'package:dio/dio.dart';

import '../models/user.dart';
import '../utils/api_service.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository({required this.apiService});

  Future<User> getUser() async {
    final response = await apiService.get('/users');
    return User.fromMap(response.data);
  }

  Future<void> updateUser(String name, String email) async {
    await apiService.put('/users', data: {'username': name, 'email': email});
  }
}
