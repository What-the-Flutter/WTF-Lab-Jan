import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: ('Home'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: ('Daily'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.exposure),
          label: ('Timeline'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.api),
          label: ('Explore'),
        )
      ],
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
          // _navigateToMenuScreen();
        });
      },
    );
  }

  void _navigateToMenuScreen() {
    if (_selectedIndex == 0) {
      Navigator.pushNamed(context, '/');
    } else if (_selectedIndex == 1) {
      Navigator.pushNamed(context, '/daily');
    } else if (_selectedIndex == 2) {
      Navigator.pushNamed(context, '/timeline');
    } else if (_selectedIndex == 3) {
      Navigator.pushNamed(context, '/explore');
    }
  }
}

Widget _appBarMenuButton() {
  return IconButton(
      icon: const Icon(Icons.menu_outlined),
      onPressed: () {
        print('Click on menu outlined button');
      });
}

class DailyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarDailyTitle(),
        leading: _appBarMenuButton(),
        actions: <Widget>[
          //_appBarRightButton(),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _appBarDailyTitle() {
    return const Align(
      child: Text('Daily'),
      alignment: Alignment.center,
    );
  }

  Widget _appBarMenuButton() {
    return IconButton(icon: const Icon(Icons.menu_open), onPressed: () {});
  }
}

class TimelineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTimelineTitle(),
        leading: _appBarMenuButton(),
        actions: <Widget>[
          _appBarSearchButton(),
          _appBarNoteButton(),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _appBarTimelineTitle() {
    return const Align(
      child: Text('Timeline'),
      alignment: Alignment.center,
    );
  }

  Widget _appBarSearchButton() {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {},
    );
  }

  Widget _appBarNoteButton() {
    return IconButton(
      icon: const Icon(Icons.note),
      onPressed: () {},
    );
  }
}

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarExploreTitle(),
        leading: _appBarMenuButton(),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _appBarExploreTitle() {
    return const Align(
      child: Text('Explore'),
      alignment: Alignment.topLeft,
    );
  }
}
