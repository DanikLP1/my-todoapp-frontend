import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: Color(0xff003CC0),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Color(0xff003CC0),
      secondary: Colors.blue[300]!,
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: Colors.blue[300],
      border: OutlineInputBorder(),
      hintStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Color(0xff003CC0),
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: Color(0xff003CC0),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xff003CC0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: Color(0xff003CC0),
    scaffoldBackgroundColor: Color.fromARGB(255, 28, 28, 28),
    colorScheme: ColorScheme.dark(
      primary: Color(0xff003CC0),
      secondary: Colors.blue[300]!,
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: Colors.blue[300],
      border: OutlineInputBorder(),
      hintStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Color(0xff003CC0),
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: Color(0xff003CC0),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xff003CC0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
