import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/bloc.dart';
import '../../utils/snackbar_util.dart';
import '../login_page/login_screen.dart';
import '../main_screen.dart';
import '../widgets/build_text.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarUtil.successSnackBar("Успешная регистрация"),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                (route) => false,
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarUtil.errorSnackBar(state.error)
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                children: [
                  Text(
                    'Новый пользователь',
                    style: theme.textTheme.displayLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Создайте нового пользователя',
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 40),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline),
                            hintText: 'user123',
                            labelText: 'Имя',
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            hintText: 'user123@gmail.com',
                            labelText: 'Электронная почта',
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: '**********',
                            labelText: 'Пароль',
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: '**********',
                            labelText: 'Подтверждение пароля',
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return CircularProgressIndicator();
                      } else {
                        return MaterialButton(
                          height: 50,
                          minWidth: 300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          color: theme.buttonTheme.colorScheme?.primary ?? theme.primaryColor,
                          onPressed: () {
                            final username = _usernameController.text;
                            final email = _emailController.text;
                            final password = _passwordController.text;
                            final confirmPassword = _confirmPasswordController.text;

                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBarUtil.errorSnackBar("Пароли должны совпадать!"),
                              );
                            } else {
                              context.read<AuthBloc>().add(
                                RegisterRequested(
                                  username: username,
                                  email: email,
                                  password: password,
                                ),
                              );
                            }
                          },
                          child: Text(
                            'ЗАРЕГИСТРИРОВАТЬСЯ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Уже зарегистрированы?",
                        style: theme.textTheme.bodyMedium,
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login',
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Войти',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
