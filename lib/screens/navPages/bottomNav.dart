import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_naka_ethos/screens/navPages/homePage.dart';
import 'package:smart_naka_ethos/screens/navPages/profile.dart';
import 'package:smart_naka_ethos/screens/navPages/filter_stolencar_history.dart';
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
  String policeID = '';
  String policeName = '';
  String policeStation = '';
  String imageURL =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvPasPbrVe2Txcc4aGbZkCddJkVTaj8uyb7A&usqp=CAU';

  @override
  void initState() {
    setPoliceDetails();
    super.initState();
  }

  setPoliceDetails() async {
    final prefs = await SharedPreferences.getInstance();
    policeID = prefs.getString('policeID') ?? '';
    policeName = prefs.getString('policeName') ?? '';
    policeStation = prefs.getString('policeStation') ?? '';
    imageURL = prefs.getString('imageURL') ?? '';
    setState(() {});
  }

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
    FilterStolenCarHistory(),
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
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: accentGreen,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(imageURL),
                      ),
                    ),
                    title: Column(
                      children: [
                        Text(policeName),
                        Text(
                          policeStation,
                          style: Theme.of(context).textTheme.bodySmall,
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
