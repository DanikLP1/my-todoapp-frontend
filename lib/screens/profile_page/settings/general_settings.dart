import 'package:flutter/material.dart';
import 'package:my_todo_app/screens/profile_page/settings/color_settings.dart'; // Импортируйте экран настроек цвета

class GeneralSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Общие настройки'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Настройки цвета'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ColorSettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Уведомления'),
            onTap: () {
              // Функционал пока не реализован
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Безопасность'),
            onTap: () {
              // Функционал пока не реализован
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Помощь и обратная связь'),
            onTap: () {
              // Функционал пока не реализован
            },
          ),
        ],
      ),
    );
  }
}
