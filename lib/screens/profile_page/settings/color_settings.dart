import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_todo_app/screens/theme/theme.dart';
import 'package:my_todo_app/screens/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class ColorSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки цвета'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Primary Color'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                showDialog<Color>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Выберите цвет Primary'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: themeNotifier.primaryColor,
                          onColorChanged: (color) {
                            themeNotifier.updatePrimaryColor(color);
                          },
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Отмена'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Сохранить'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Выберите цвет Primary'),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeNotifier.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Text('Secondary Color'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                showDialog<Color>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: themeNotifier.secondaryColor,
                          onColorChanged: (color) {
                            themeNotifier.updateSecondaryColor(color);
                          },
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Отмена'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Сохранить'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Выберите цвет Secondary'),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeNotifier.secondaryColor,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Сбросить цвета до значений по умолчанию
                themeNotifier.updatePrimaryColor(AppTheme.primaryColor);
                themeNotifier.updateSecondaryColor(AppTheme.secondaryColor);
              },
              child: Text('Исправить цвета по умолчанию'),
            ),
          ],
        ),
      ),
    );
  }
}
