import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'event_page.dart';
import 'light_theme.dart';
import 'note.dart';
import 'note_page.dart';
import 'theme.dart';

class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isThemeChange = false;
  List<Note> noteList = [
    Note(
      'Drinks',
      CircleAvatar(
        child: Icon(
          Icons.liquor,
        ),
      ),
      'Add event',
    ),
    Note(
      'FastFood',
      CircleAvatar(
        child: Icon(
          Icons.fastfood,
        ),
      ),
      'Add event',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer,
      body: _homePageBody(),
      appBar: _appBar,
      bottomNavigationBar: _bottomNavigationBar,
      floatingActionButton: _floatingActionButton,
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: Center(
        child: Text(
          'Home',
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.invert_colors),
          onPressed: () {
            _isThemeChange
                ? ThemeSwitcher.of(context).switchTheme(lightTheme)
                : ThemeSwitcher.of(context).switchTheme(darkTheme);
            changeTheme();
          },
        ),
      ],
    );
  }

  void changeTheme() {
    setState(
      () {
        _isThemeChange = !_isThemeChange;
      },
    );
  }

  ListView _homePageBody() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: noteList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(noteList[index].eventName),
        leading: IconButton(
          icon: noteList[index].iconData,
          iconSize: 40,
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
          setState(
            () {},
          );
        },
        onLongPress: () => _showBottomSheet(context, index),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 170,
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
            Icons.info_outline,
            color: Colors.green[700],
          ),
          title: Text('Info'),
        ),
        ListTile(
          leading: Icon(
            Icons.edit,
            color: Colors.blue[700],
          ),
          title: Text('Edit'),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotePage(
                  note: noteList[index],
                ),
              ),
            );
            setState(
              () {},
            );
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: Text('Delete'),
          onTap: () {
            _deleteNote(index);
          },
        ),
      ],
    );
  }

  void _deleteNote(int index) {
    setState(
      () {
        noteList.removeAt(index);
        Navigator.pop(context);
      },
    );
  }

  Drawer get _drawer {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text('Profile'),
          ),
          ListTile(
            title: Text('Password'),
          ),
          ListTile(
            title: Text('Exit'),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar get _bottomNavigationBar {
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
    );
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotePage(
              noteList: noteList,
            ),
          ),
        );
        setState(
          () {},
        );
      },
      child: Icon(Icons.add),
    );
  }
}
