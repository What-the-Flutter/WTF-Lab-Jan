import 'package:flutter/material.dart';
import 'package:personal_chat/screens/daily_screen.dart';
import 'package:personal_chat/screens/explore_screen.dart';
import 'package:personal_chat/screens/timeline_screen.dart';
import 'package:personal_chat/screens/home_screen.dart';

import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Personal Chat', home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    DailyScreen(),
    TimelineScreen(),
    ExploreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],

      // Here we have bottomNavigationBar and a button for adding a chat.
      bottomNavigationBar: Container(
        height: 90,
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 20),
        decoration: BoxDecoration(
            color: pinkDecor, borderRadius: BorderRadius.circular(40)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.red,
          unselectedItemColor: black,
          selectedIconTheme: IconThemeData(size: 30.0),
          iconSize: 25.0,
          selectedFontSize: 15,
          showUnselectedLabels: true,
          elevation: 0,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.assignment_rounded,
              ),
              label: 'Daily',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.timer,
              ),
              label: 'Timeline',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.explore_outlined,
              ),
              label: 'Explore',
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
