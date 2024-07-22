import 'package:flutter/material.dart';

class AppTheme {
  static final primaryColor = Color.fromARGB(255, 24, 136, 216);
  static final secondaryColor = Colors.cyan[200]!;

  static final lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white, // Цвет карточки в светлой теме
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
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
        color: primaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: primaryColor,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      textTheme: ButtonTextTheme.primary,
    ),
    // Добавление цветов для skeleton в светлой теме
    extensions: <ThemeExtension>[
      SkeletonColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
      ),
    ],
  );

  static final darkTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Color.fromARGB(255, 28, 28, 28),// Цвет карточки в темной теме
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
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
        color: primaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: primaryColor,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      textTheme: ButtonTextTheme.primary,
    ),
    // Добавление цветов для skeleton в темной теме
    extensions: <ThemeExtension>[
      SkeletonColors(
        baseColor: Colors.grey[700]!,
        highlightColor: Colors.grey[500]!,
      ),
    ],
  );
}

class SkeletonColors extends ThemeExtension<SkeletonColors> {
  final Color baseColor;
  final Color highlightColor;

  SkeletonColors({required this.baseColor, required this.highlightColor});

  @override
  SkeletonColors copyWith({Color? baseColor, Color? highlightColor}) {
    return SkeletonColors(
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  SkeletonColors lerp(ThemeExtension<SkeletonColors>? other, double t) {
    if (other is! SkeletonColors) return this;
    return SkeletonColors(
      baseColor: Color.lerp(baseColor, other.baseColor, t)!,
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
    );
  }
}
