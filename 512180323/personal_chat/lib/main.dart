import 'package:flutter/material.dart';

import 'constants.dart';
import 'screens/daily_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/home_screen.dart';
import 'screens/timeline_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Personal Chat',
      home: MainScreen(),
    );
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
    const HomeScreen(),
    const DailyScreen(),
    const TimelineScreen(),
    const ExploreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Container(
        color: pinkBg,
        child: Container(
          height: 90,
          margin: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 5.0, bottom: 20),
          decoration: BoxDecoration(
            color: pinkDecor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.blue,
            unselectedItemColor: black,
            selectedIconTheme: const IconThemeData(size: 23.0),
            iconSize: 25.0,
            selectedFontSize: 12,
            showUnselectedLabels: true,
            elevation: 0,
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.assignment_rounded,
                ),
                label: 'Daily',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.timer,
                ),
                label: 'Timeline',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.explore_outlined,
                ),
                label: 'Explore',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTabTapped(int index) => setState(
        () {
          _currentIndex = index;
        },
      );
}
