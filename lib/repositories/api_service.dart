import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_todo_app/models/tokens.dart';
import 'package:my_todo_app/utils/snackbar_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/blocs/auth/bloc.dart';

class ApiService {
  final Dio _dio;
  final String _baseUrl;
  final GlobalKey<NavigatorState> navigatorKey;

  ApiService({required String baseUrl, required this.navigatorKey})
      : _baseUrl = baseUrl,
        _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await _getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
    ));
  }

  Future<String?> _getAccessToken() async {
    final token = await getTokensFromStorage();
    return token?.accessToken;
  }

  Future<void> _initializeTokens() async {
    final tokens = await getTokensFromStorage();
    if (tokens != null) {
      setTokens(tokens.accessToken, tokens.refreshToken);
    }
  }

  void setTokens(String accessToken, String refreshToken) {
    _dio.options.headers['Authorization'] = 'Bearer $accessToken';
  }

  Future<AuthToken?> getTokensFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');
    if (accessToken != null && refreshToken != null) {
      return AuthToken(accessToken: accessToken, refreshToken: refreshToken);
    }
    return null;
  }

  Future<Response> get(String path, {dynamic data}) async {
    return await _withTokenRefresh(() => _dio.get(path, queryParameters: data));
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _withTokenRefresh(() => _dio.post(path, data: data));
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _withTokenRefresh(() => _dio.put(path, data: data));
  }

  Future<Response> delete(String path, {dynamic data}) async {
    return await _withTokenRefresh(() => _dio.delete(path, data: data));
  }

  Future<Response<T>> _withTokenRefresh<T>(Future<Response<T>> Function() request) async {
    try {
      final response = await request();
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Unauthorized: Token expired, attempt to refresh tokens
        final refreshed = await _refreshTokens();
        if (refreshed) {
          // Retry request with new tokens
          final retryResponse = await request();
          return retryResponse;
        } else {
          // Failed to refresh tokens, handle accordingly
          await _handleUnauthorized();
          throw DioException(
            requestOptions: e.requestOptions,
            response: e.response,
            type: DioExceptionType.badResponse,
            error: 'Ваш срок авторизации истек, войдите заново: ${e.response?.data['message']}',
          );
        }
      } else {
        // Other DioErrors, handle accordingly
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: DioExceptionType.unknown,
          error: e.response?.data['message'] ?? 'Неизвестная ошибка',
        );
      }
    }
  }

  Future<bool> _refreshTokens() async {
    try {
      final tokens = await getTokensFromStorage();
      if (tokens?.refreshToken == null) {
        return false; // No refresh token available
      }

      final refreshDio = Dio(BaseOptions(baseUrl: _baseUrl));
      final response = await refreshDio.post('/auth/refresh',
        options: Options(
          headers: {'Authorization': 'Bearer ${tokens!.refreshToken}'}
        ),
      );
      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      if (newAccessToken != null && newRefreshToken != null) {
        await saveTokensToStorage(newAccessToken, newRefreshToken);
        setTokens(newAccessToken, newRefreshToken);
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      debugPrint('Failed to refresh tokens: ${e.message}');
      SnackBarUtil.errorSnackBar('Ваш срок авторизации истек, войдите заново');
      await clearTokens();
      return false;
    }
  }

  Future<void> saveTokensToStorage(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    _dio.options.headers.remove('Authorization');
  }

  Future<void> _handleUnauthorized() async {
    await clearTokens();
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
    BlocProvider.of<AuthBloc>(navigatorKey.currentContext!).add(LogoutRequested());
  }
}
