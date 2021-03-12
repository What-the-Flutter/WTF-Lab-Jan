import 'package:flutter/material.dart';

import 'event_page.dart';
import 'note.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Note> noteList = [
    Note(
      'Sport',
      CircleAvatar(
        child: Icon(
          Icons.sports_soccer,
        ),
      ),
      '',
    ),
    Note(
      'FastFood',
      CircleAvatar(
        child: Icon(
          Icons.fastfood,
        ),
      ),
      '',
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _floatingActionButton,
        appBar: _appBar,
        drawer: _drawer,
        bottomNavigationBar: _bottomNavigationBar,
        body: _homePageBody(),
    );
  }

  ListView _homePageBody() {
    return ListView.builder(
      itemCount: noteList.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) => ListTile(
        title: Text(noteList[index].eventName),
        leading: IconButton(
          icon: noteList[index].iconData,
          iconSize: 50,
          onPressed: () {},
        ),
        subtitle: Text(noteList[index].subTittleEvent),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventPage(
                title: noteList[index].eventName,
                note: noteList[index],
              ),
            ),
          );
        },
      ),
    );
  }


  BottomNavigationBar get _bottomNavigationBar {
    return BottomNavigationBar(
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
      selectedItemColor: Colors.deepPurple,
      showUnselectedLabels: true,
    );
  }

  Drawer get _drawer {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
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
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: Center(
        child: Text('Home'),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.invert_colors),
          onPressed: () {},
        ),
      ],
    );
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(child: Icon(Icons.add),
      onPressed: () {},
    );
  }
}