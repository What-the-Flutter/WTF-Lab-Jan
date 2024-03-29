import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'categories_view.dart';
import 'theme_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDarkTheme = false;
  int _currentScreenIndex = 0;

  late final List<Widget> _currentScreenBody = [
    const CategoriesListPage(),
    _dailyBody(),
    _timeLineBody()
  ];

  void _changeTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;

      final provider = Provider.of<ThemeProvider>(context, listen: false);
      provider.toggleTheme(_isDarkTheme);
    });
  }

  void _onBottomBarItemTapped(int index) {
    setState(() => _currentScreenIndex = index);
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(widget.title),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(_isDarkTheme ? Icons.brightness_3 : Icons.brightness_5),
            tooltip: _isDarkTheme ? 'Dark Theme' : 'Light Theme',
            onPressed: _changeTheme,
          ),
        ),
      ],
    );
  }

  Widget _drawer() {
    return const Drawer(
      child: Text(
        'Empty Drawer',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 48),
      ),
    );
  }

  Widget _dailyBody() {
    return const Center(
      child: Text(
        'Daily',
      ),
    );
  }

  Widget _timeLineBody() {
    return const Center(
      child: Text(
        'Time Line',
      ),
    );
  }

  BottomNavigationBar _bottomBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_note),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chrome_reader_mode),
          label: 'Timeline',
        ),
      ],
      currentIndex: _currentScreenIndex,
      onTap: _onBottomBarItemTapped,
    );
  }

  @override
  Widget build(BuildContext _) {
    return Scaffold(
      appBar: _appBar(),
      drawer: _drawer(),
      body: _currentScreenBody[_currentScreenIndex],
      bottomNavigationBar: _bottomBar(),
    );
  }
}
