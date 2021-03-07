import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton (
        child: Icon( Icons.add),
        onPressed: () {},
      ),
      appBar: AppBar(
        title: Center(
          child: Text('Home'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.invert_colors),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Information',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
            label: 'TimeLine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text(
              'Food',
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.sports_soccer),
            title: Text(
              'Sport',
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
