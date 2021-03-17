import 'package:flutter/material.dart';

import 'create_page.dart';
import 'dark_theme.dart';
import 'event_page.dart';
import 'light_theme.dart';
import 'note.dart';
import 'theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _themeSwitcher = false;
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
          icon: noteList[index].circleAvatar,
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
          setState(() {});
        },
        onLongPress: () {
          _showBottomSheet(context, index);
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
      showUnselectedLabels: true,
    );
  }

  Drawer get _drawer {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
          onPressed: () {
              _themeSwitcher
                  ? ThemeSwitcher.of(context).switchTheme(lightThemeData)
                  : ThemeSwitcher.of(context).switchTheme(darkThemeData);
              _themeSwitcher = !_themeSwitcher;
          },
        ),
      ],
    );
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePage(
              noteList: noteList,
              isEditing: false,
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  void _showBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 120,
          child: _buildBottomNavigationMenu(index),
        );
      },
    );
  }

  Column _buildBottomNavigationMenu(int index) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          title: Text('Edit'),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePage(
                  isEditing: true,
                  noteList: noteList,
                  index: index,
                ),
              ),
            );
            setState(() {});
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.black,
          ),
          title: Text('Delete'),
          onTap: () {
            setState(() {
              noteList.removeAt(index);
              Navigator.pop(context);
            });
          },
        ),
      ],
    );
  }
}
