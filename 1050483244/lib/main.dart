import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/all_pages.dart';
import 'package:jiffy/jiffy.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Journal',
      theme: theme,
      home: Main(),
    );
  }
}

final theme = ThemeData(
  primaryColor: Colors.teal[700],
);

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    DailyPage(),
    TimelinePage(),
    ExplorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
        actions: [
          IconButton(
            icon: const Icon(Icons.invert_colors_outlined),
            tooltip: 'Switch Theme',
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal[700],
              ),
              child: Column(
                verticalDirection: VerticalDirection.up,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Jiffy(DateTime.now()).format('MMM d, yyyy'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ],
              )),
          ListTile(
            leading: Icon(Icons.card_giftcard_outlined),
            title: Text('Help spread the word'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.search_outlined),
            title: Text('Search'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.multiline_chart_outlined),
            title: Text('Statistics'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text('Feedback'),
            onTap: () {},
          ),
        ],
      )),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
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
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
      ),
    );
  }
}
