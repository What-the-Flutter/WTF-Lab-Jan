import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Profile')),
            ListTile(
              title: Text('Password'),
            ),
            ListTile(
              title: Text('Exit'),
            )
          ],
        ),
      ),
      body: BodyLayout(),
      appBar: AppBar(
        title: Center(
          child: Text('Home'),
        ),
        actions: [
          IconButton(icon: Icon(Icons.invert_colors), onPressed: () {}),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myBottomNavigationBar(context);
  }
}

Widget _myBottomNavigationBar(BuildContext context) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_view_day_sharp),
        label: 'Daily',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.timeline),
        label: 'Timeline',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.explore),
        label: 'Explore',
      ),
    ],
    unselectedItemColor: Colors.blueGrey,
    selectedItemColor: Colors.blue,
    showUnselectedLabels: true,
  );
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {
  return ListView(
    scrollDirection: Axis.vertical,
    children: <Widget>[
      ListTile(
        title: Text('Drinks'),
        leading: IconButton(icon: Icon(Icons.liquor)),
        subtitle: Text('No events yet.'),
      ),
      Divider(
        color: Colors.grey,
      ),
      ListTile(
        title: Text('FastFood'),
        leading: IconButton(icon: Icon(Icons.fastfood)),
        subtitle: Text('No events yet.'),
      ),
    ],
  );
}
