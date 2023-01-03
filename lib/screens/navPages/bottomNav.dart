import 'package:flutter/material.dart';
import 'package:smart_naka_ethos/screens/navPages/homePage.dart';
import 'package:smart_naka_ethos/utils/constants.dart';

import 'add_missing_diary.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 2;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print(_selectedIndex);
  }

  static const bottomNavigationBarItemList = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.car_crash_rounded),
      label: 'Car History',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.track_changes),
      label: 'Track a Car',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.book),
      label: 'Add Missing Diary',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  static const List<Widget> _pages = <Widget>[
    Icon(
      Icons.call,
      size: 150,
    ),
    Icon(
      Icons.camera,
      size: 150,
    ),
    HomePage(),
    AddMissingDiary(),
    Icon(
      Icons.chat,
      size: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        items: bottomNavigationBarItemList,
        onTap: _onItemTapped,
        backgroundColor: BACKGROUND_DARK,
        selectedItemColor: ACCENT_GREEN,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
