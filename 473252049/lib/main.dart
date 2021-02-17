import 'package:flutter/material.dart';

import 'mocks/mocks.dart';
import 'model/category.dart';
import 'views/category_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _children = [
    CategoriesPageContent(mockCategories),
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
        onTap: (index) => _onTabTap(index),
      ),
    );
  }
}

Widget _drawerHeader() {
  return Container(
    child: Column(
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
    ),
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

class CategoriesPageContent extends StatelessWidget {
  final List<Category> _categories;

  CategoriesPageContent(this._categories);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _categories.length + 1,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) => index == 0
          ? _questionnaireBot(context)
          : CategoryView(_categories[index - 1]),
    );
  }
}

Widget _questionnaireBot(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
    child: TextButton(
      style: Theme.of(context).textButtonTheme.style,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              Icons.chat,
              size: 28,
            ),
          ),
          Text(
            'Questionnaire Bot',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
      onPressed: () {},
    ),
  );
}
