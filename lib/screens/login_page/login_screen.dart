import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/screens/register_page/register_screen.dart';
import 'package:my_todo_app/utils/snackbar_util.dart';
import '../../blocs/auth/bloc.dart';
import '../main_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final padding = width * 0.05;
    final imageSize = width * 0.3;
    final buttonHeight = height * 0.07;
    final buttonWidth = width * 0.8;
    final spacing = height * 0.02;
    
    return SafeArea(
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarUtil.errorSnackBar(state.error),
              );
            } else if (state is AuthAuthenticated) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MainPage()),
              );
            } else if (state is AuthUnauthenticated) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/ice-cream.png',
                    height: imageSize,
                    width: imageSize,
                  ),
                  SizedBox(height: spacing),
                  Text(
                    'Добро пожаловать',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: width * 0.06),
                  ),
                  SizedBox(height: spacing),
                  Text(
                    'Войдите, чтобы продолжить',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: width * 0.05),
                  ),
                  SizedBox(height: height * 0.05),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'user123@gmail.com',
                            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                            labelText: 'Электронная почта',
                          ),
                        ),
                        SizedBox(height: spacing),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            border: OutlineInputBorder(),
                            hintText: '********',
                            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                            labelText: 'Пароль',
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Забыли пароль?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.04,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: spacing),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return CircularProgressIndicator();
                      }

                      return MaterialButton(
                        height: buttonHeight,
                        minWidth: buttonWidth,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(buttonHeight / 2)),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          final username = _usernameController.text;
                          final password = _passwordController.text;
                          context.read<AuthBloc>().add(
                            LoginRequested(email: username, password: password),
                          );
                        },
                        child: Text(
                          'ВОЙТИ',
                          style: TextStyle(
                            fontSize: width * 0.05,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: spacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "У вас нет аккаунта?",
                        style: TextStyle(fontSize: width * 0.04),
                      ),
                      SizedBox(width: width * 0.02),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/register',
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Создать аккаунт',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
