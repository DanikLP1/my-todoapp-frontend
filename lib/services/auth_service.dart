import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_todo_app/model/user.dart';
import 'package:my_todo_app/providers/user_provider.dart';
import 'package:my_todo_app/screens/home_screen.dart';
import 'package:my_todo_app/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../utils/utils.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      User user = User(
        id: -1, 
        username: '', 
        email: '', 
        passwordHash: '',
        createdAt: '',
        updatedAt: '',
        hashedRt: ''
      );
      
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/auth/local/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }
      );


      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context, 
            'Account created! Login with the same credentials!',
          );
        }
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      log(e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String emailOrName,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/auth/local/signin'),
        body: jsonEncode({
          'email': emailOrName,
          'username': emailOrName,
          'password': password
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', jsonDecode(res.body)['access_token']);
          await prefs.setString('refresh_token', jsonDecode(res.body)['refresh_token']);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        }
      );

    } catch (e) {
      showSnackBar(context, e.toString());
      log(e.toString());
    }
  }

  void getUserData(
    BuildContext context
  ) async {
    try{
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if(token == null) {
        prefs.setString('access_token', '');
      }

      http.Response res = await http.get(
        Uri.parse('${Constants.uri}/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: () {
          log(res.body);
          userProvider.setUser(res.body);
        }
      );


    } catch(e) {
      showSnackBar(context, e.toString());
      log(e.toString());
    }
  }

  void logout({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final navigator = Navigator.of(context);

      String? token = prefs.getString('access_token');
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/auth/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: () async {
          await prefs.setString('access_token', '');
          await prefs.setString('refresh_token', '');
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const SignupScreen(),
            ),
            (route) => false,
          );
        }
      );

    } catch(e) {
      showSnackBar(context, e.toString());
      log(e.toString());
    }
  }
}