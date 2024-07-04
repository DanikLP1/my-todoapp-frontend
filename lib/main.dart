import 'package:flutter/material.dart';
import 'package:my_todo_app/providers/user_provider.dart';
import 'package:my_todo_app/screens/home_screen.dart';
import 'package:my_todo_app/screens/login_screen.dart';
import 'package:my_todo_app/screens/signup_screen.dart';
import 'package:my_todo_app/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: const MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(builder: (BuildContext context) {
        authService.getUserData(context);
        return Provider.of<UserProvider>(context).user.hashedRt.isEmpty ? const SignupScreen() : const HomeScreen();
      }),
    );
  }
}
