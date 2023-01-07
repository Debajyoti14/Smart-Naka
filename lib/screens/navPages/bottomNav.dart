import 'package:flutter/material.dart';
import 'package:smart_naka_ethos/screens/navPages/homePage.dart';
import 'package:smart_naka_ethos/screens/navPages/profile.dart';
import 'package:smart_naka_ethos/screens/navPages/retrived_cars.dart';
import 'package:smart_naka_ethos/screens/navPages/track_car.dart';
import 'package:smart_naka_ethos/utils/constants.dart';

import 'add_missing_diary.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 2;
  bool isOnDuty = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
    RetrivedCars(),
    TrackCar(),
    HomePage(),
    AddMissingDiary(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        items: bottomNavigationBarItemList,
        onTap: _onItemTapped,
        backgroundColor: backgroundDark,
        selectedItemColor: accentGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      appBar: (_selectedIndex != 4)
          ? AppBar(
              backgroundColor: backgroundDark,
              toolbarHeight: 80,
              flexibleSpace: Column(
                children: [
                  const SizedBox(height: 50),
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundColor: accentGreen,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7Xh9PifMRhzJfnv4DVRnhcFv1DsMB0RtcAQ&usqp=CAU'),
                      ),
                    ),
                    title: Column(
                      children: [
                        const Text('Chingam Pandey'),
                        Text(
                          'Head Belgharia Branch',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                    trailing: Switch(
                      activeColor: accentGreen,
                      activeTrackColor: Colors.white,
                      inactiveThumbColor: Colors.blueGrey.shade600,
                      inactiveTrackColor: Colors.grey.shade400,
                      splashRadius: 50.0,
                      value: isOnDuty,
                      onChanged: (value) {
                        setState(() {
                          isOnDuty = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          : AppBar(toolbarHeight: 0),
    );
  }
}
