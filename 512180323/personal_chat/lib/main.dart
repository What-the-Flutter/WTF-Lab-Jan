import 'package:flutter/material.dart';

import 'constants.dart';
import 'custom_theme.dart';
import 'screens/daily_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/home_screen.dart';
import 'screens/timeline_screen.dart';

void main() {
  runApp(
    CustomTheme(
      initialThemeKey: CustomThemeKeys.dark,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Chat',
      theme: CustomTheme.of(context),
      home: const MainScreen(),
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
        color: Theme.of(context).backgroundColor,
        child: Container(
          height: 90,
          margin: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 5.0, bottom: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Theme.of(context).textSelectionColor,
            unselectedItemColor: Theme.of(context).unselectedWidgetColor,
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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
