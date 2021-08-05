import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_page.dart';
import 'services/my_themes.dart';
import 'services/switch_themes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(),
      child: Builder(
        builder: (context) {
          final themeChanger = Provider.of<ThemeChanger>(context);
          return MaterialApp(
            title: 'Chat Journal',
            themeMode: themeChanger.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: MyMainPage(),
          );
        },
      ),
    );
  }
}

class MyMainPage extends StatefulWidget {
  const MyMainPage({Key? key}) : super(key: key);

  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  final List<Widget> _pages = [
    MyHomePage(),
    Container(color: Colors.red),
    Container(color: Colors.blue),
    Container(color: Colors.green),
    Container(color: Colors.black)
  ];
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_sharp), label: 'Daily'),
            BottomNavigationBarItem(
                icon: Icon(Icons.timeline), label: 'Timeline'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore')
          ],
          type: BottomNavigationBarType.fixed),
    );
  }
}
