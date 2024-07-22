import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:my_todo_app/screens/calendar_page/calendar_page.dart';
import 'package:my_todo_app/screens/login_page/login_screen.dart';
import 'package:my_todo_app/screens/home_page.dart';
import 'package:my_todo_app/screens/profile_page/profile_page.dart';

import '../blocs/auth/bloc.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _selectedIndex,
      viewportFraction: 1.0, // Установите в 1.0 для полного экрана
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      HomePage(),
      CalendarPage(),
      ProfilePage(),
    ];

    const List<String> _pageTitles = [
      'Главная',
      'Задачи',
      'Профиль',
    ];

    // Получение ширины и высоты экрана
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Адаптивные размеры
    final bottomBarHeight = screenHeight * 0.1; // 10% от высоты экрана
    final iconSize = screenWidth * 0.079; // 8% от ширины экрана
    final fontSize = screenWidth * 0.045; // 4.5% от ширины экрана
    final itemPadding = EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01);

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
      bottomNavigationBar: Container(
        height: bottomBarHeight, // Адаптивная высота BottomBar
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03), // Адаптивный вертикальный padding
        child: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          itemPadding: itemPadding, // Адаптивный padding элементов
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.home, size: iconSize), // Адаптивный размер иконок
              title: Text('Главная', style: TextStyle(fontSize: fontSize)), // Адаптивный размер текста
              selectedColor: Theme.of(context).primaryColor,
              unselectedColor: Colors.grey,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.calendar_month, size: iconSize),
              title: Text('Задачи', style: TextStyle(fontSize: fontSize)),
              selectedColor: Theme.of(context).primaryColor,
              unselectedColor: Colors.grey,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.person, size: iconSize),
              title: Text('Профиль', style: TextStyle(fontSize: fontSize)),
              selectedColor: Theme.of(context).primaryColor,
              unselectedColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
