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
    return SafeArea(
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              log(state.error);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarUtil.errorSnackBar(state.error),
              );
            } else if (state is AuthAuthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarUtil.successSnackBar("Успешная авторизация"),
              );
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
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/ice-cream.png',
                    height: 100,
                    width: 100,
                  ),
                  Text(
                    'Добро пожаловать',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    'Войдите, чтобы продлолжить',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 50),
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
                        SizedBox(height: 30),
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return CircularProgressIndicator();
                      }

                      return MaterialButton(
                        height: 50,
                        minWidth: 300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
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
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("У вас нету аккаунта?"),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Создать новый аккаунт',
                          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold,),
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
