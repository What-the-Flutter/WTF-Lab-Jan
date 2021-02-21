import 'package:flutter/material.dart';

import '../mocks/mocks.dart';
import 'content/home_page_content.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _children = [
    HomePageContent(mockCategories, key: homePageContentStateKey),
    Placeholder(),
    Placeholder(),
    Placeholder(),
  ];

  var _currentPageIndex = 0;

  void _onTabTap(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.bedtime_outlined),
            onPressed: () {},
            tooltip: 'Switch theme',
          )
        ],
      ),
      body: _children[_currentPageIndex],
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: _drawerHeader(),
            ),
            ..._drawerItemsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [..._bottomNavigationBarItems()],
        onTap: _onTabTap,
      ),
    );
  }
}

Widget _drawerHeader() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Text(
        'Feb 16, 2021',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      Text(
        '(Click here to setup Drive backups)',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
    ],
  );
}

List<Widget> _drawerItemsList() {
  return [
    _drawerItem(Icons.card_giftcard, 'Help spread the world', () {}),
    _drawerItem(Icons.search, 'Search', () {}),
    _drawerItem(Icons.notifications, 'Notifications', () {}),
    _drawerItem(Icons.whatshot, 'Statistics', () {}),
    _drawerItem(Icons.settings, 'Settings', () {}),
    _drawerItem(Icons.feedback, 'Feedback', () {}),
  ];
}

ListTile _drawerItem(IconData icon, String text, void Function() onTap) {
  return ListTile(
    title: Text(text),
    leading: Icon(icon),
    onTap: onTap,
  );
}

List<BottomNavigationBarItem> _bottomNavigationBarItems() {
  return [
    BottomNavigationBarItem(
      icon: Icon(Icons.book),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.paste),
      label: 'Daily',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.map),
      label: 'Timeline',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.explore),
      label: 'Explore',
    ),
  ];
}
