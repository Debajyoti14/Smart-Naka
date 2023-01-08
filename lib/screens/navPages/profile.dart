import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_naka_ethos/screens/auth/login.dart';
import 'package:smart_naka_ethos/widgets/green_buttons.dart';

import '../../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkTheme = true;
  String policeID = '';
  String policeName = '';
  String policeStation = '';
  String imageURL =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvPasPbrVe2Txcc4aGbZkCddJkVTaj8uyb7A&usqp=CAU';
  @override
  void initState() {
    super.initState();
    setPoliceDetails();
  }

  setPoliceDetails() async {
    final prefs = await SharedPreferences.getInstance();
    policeID = prefs.getString('policeID') ?? '';
    policeName = prefs.getString('policeName') ?? '';
    policeStation = prefs.getString('policeStation') ?? '';
    imageURL = prefs.getString('imageURL') ??
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWeTekI6pbMf77pjGcHI2id9k1U8IdM5WtGg&usqp=CAU';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: accentGreen,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(imageURL),
                  ),
                ),
              ),
              Text(
                policeName,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                policeStation,
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.restore,
                      color: accentGreen,
                    ),
                    SizedBox(
                      width: 258,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'View Cars Retrived',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'You can view you daily personal phone usages analytics',
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.colorize,
                      color: accentGreen,
                    ),
                    SizedBox(
                      width: 258,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Theme',
                            style: TextStyle(fontSize: 20),
                          ),
                          Switch(
                            activeColor: accentGreen,
                            activeTrackColor: Colors.white,
                            inactiveThumbColor: Colors.blueGrey.shade600,
                            inactiveTrackColor: Colors.grey.shade400,
                            splashRadius: 50.0,
                            value: isDarkTheme,
                            onChanged: (value) {
                              setState(() {
                                isDarkTheme = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.book_sharp,
                      color: accentGreen,
                    ),
                    SizedBox(
                      width: 258,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Terms & Conditions',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'You can view you daily personal phone usages analytics',
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.other_houses,
                      color: accentGreen,
                    ),
                    SizedBox(
                      width: 258,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'You can view you daily personal phone usages analytics',
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              CustomGreenButton(
                buttonText: 'Log Out',
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);
                  await prefs.remove('policeID');
                  await prefs.remove('policeName');
                  await prefs.remove('policeStation');
                  await prefs.remove('imageURL');

                  if (!mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
