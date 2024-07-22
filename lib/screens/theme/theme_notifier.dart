import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_todo_app/screens/theme/theme.dart';

class ThemeNotifier extends ChangeNotifier {
  Color _primaryColor;
  Color _secondaryColor;

  ThemeNotifier(this._primaryColor, this._secondaryColor);

  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;

  // Метод для загрузки сохраненных настроек
  static Future<ThemeNotifier> load() async {
    final prefs = await SharedPreferences.getInstance();
    final primaryColorValue = prefs.getInt('primaryColor') ?? AppTheme.primaryColor.value;
    final secondaryColorValue = prefs.getInt('secondaryColor') ?? AppTheme.secondaryColor.value;

    return ThemeNotifier(
      Color(primaryColorValue),
      Color(secondaryColorValue),
    );
  }

  // Метод для сохранения настроек
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('primaryColor', _primaryColor.value);
    await prefs.setInt('secondaryColor', _secondaryColor.value);
  }

  void updatePrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
    _saveSettings(); // Сохраняем изменения
  }

  void updateSecondaryColor(Color color) {
    _secondaryColor = color;
    notifyListeners();
    _saveSettings(); // Сохраняем изменения
  }

  ThemeData get lightTheme {
    return ThemeData(
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
      ),
      scaffoldBackgroundColor: Colors.white,
      extensions: <ThemeExtension<dynamic>>[
        SkeletonColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
        ),
      ],
      // Другие настройки темы
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
      ),
      scaffoldBackgroundColor: Color.fromARGB(255, 28, 28, 28),
      extensions: <ThemeExtension<dynamic>>[
        SkeletonColors(
          baseColor: Colors.grey[700]!,
          highlightColor: Colors.grey[500]!,
        ),
      ],
      // Другие настройки темы
    );
  }

  SkeletonColors? getSkeletonColors(ThemeData themeData) {
    return themeData.extension<SkeletonColors>();
  }
}
