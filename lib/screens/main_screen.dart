import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/screens/calendar_page/calendar_page.dart';
import 'package:my_todo_app/screens/login_page/login_screen.dart';

import '../blocs/auth/bloc.dart';
import 'home_page.dart';
import 'profile_page.dart';
import '../models/task.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  Map<DateTime, List<Event>> _events = {};
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeEvents();
  }

  void _initializeEvents() {
    _events = {
      DateTime.utc(2024, 7, 13): [
        Event('Событие 1', 'Описание события 1'),
        Event('Событие 2', 'Описание события 2')
      ],
      DateTime.utc(2024, 7, 14): [
        Event('Событие 3', 'Описание события 3')
      ],
      DateTime.utc(2024, 7, 15): [
        Event('Событие 4', 'Описание события 4'),
        Event('Событие 5', 'Описание события 5')
      ],
      DateTime.utc(2024, 7, 16): [
        Event('Событие 6', 'Описание события 6'),
        Event('Событие 7', 'Описание события 7'),
        Event('Событие 8', 'Описание события 8'),
        Event('Событие 9', 'Описание события 9'),
        Event('Событие 10', 'Описание события 10')
      ],
    };
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

  @override
  Widget build(BuildContext context) {
    final todayEvents = _events[DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day)] ?? [];

    List<Widget> _pages = <Widget>[
      HomePage(events: todayEvents),
      CalendarPage(events: _events),
      ProfilePage(),
    ];

    const List<String> _pageTitles = [
      'Главная',
      'Задачи',
      'Профиль',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _pageTitles[_selectedIndex],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavigationBarItem(Icons.home, 'Главная', 0),
            _buildBottomNavigationBarItem(Icons.calendar_month, 'Задачи', 1),
            _buildBottomNavigationBarItem(Icons.person, 'Профиль', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? Theme.of(context).primaryColor : Colors.grey;
    final iconSize = isSelected ? 30.0 : 24.0;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.3) : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(icon, color: color, size: iconSize),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    label,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
