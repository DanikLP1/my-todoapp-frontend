import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/screens/calendar_page/calendar_page.dart';
import 'package:my_todo_app/screens/login_page/login_screen.dart';

import '../blocs/auth/bloc.dart';
import 'home_page.dart';
import 'profile_page/profile_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handlePageChange);
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange);
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChange() {
    setState(() {
      _selectedIndex = _pageController.page!.round();
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double alignmentX = -1.0;
                if (_pageController.hasClients && _pageController.page != null) {
                  alignmentX = (_pageController.page! - 1) * (2 / (_pages.length - 1));
                } else {
                  alignmentX = (_selectedIndex - 1) * (2 / (_pages.length - 1));
                }
                return Align(
                  alignment: Alignment(alignmentX, 0),
                  child: Container(
                    height: 56,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavigationBarItem(Icons.home, 'Главная', 0),
                _buildBottomNavigationBarItem(Icons.calendar_month, 'Задачи', 1),
                _buildBottomNavigationBarItem(Icons.person, 'Профиль', 2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? Theme.of(context).primaryColor : Colors.grey;
    final iconSize = isSelected ? 30.0 : 24.0;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Container(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
