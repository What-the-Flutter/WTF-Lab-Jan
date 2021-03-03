import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'create_page.dart';
import 'event_page.dart';
import 'note_page.dart';
import 'themes/dark_theme.dart';
import 'themes/light_theme.dart';
import 'themes/theme_switcher.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  final darkTheme = darkThemeData;
  final lightTheme = lightThemeData;
  bool _isLightTheme = true;

  List<NotePage> noteList = [
    NotePage(
      Text(
        'Travel',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Text(
        'No events. Click to create one.',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      CircleAvatar(
        child: Icon(Icons.airplanemode_active),
      ),
    ),
    NotePage(
      Text(
        'Family',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Text(
        'No events. Click to create one.',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      CircleAvatar(
        child: Icon(Icons.family_restroom),
      ),
    ),
    NotePage(
      Text(
        'Sports',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Text(
        'No events. Click to create one.',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      CircleAvatar(
        child: Icon(Icons.sports_basketball),
      ),
    ),
    NotePage(
      Text(
        'Food',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Text(
        'No events. Click to create one.',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      CircleAvatar(
        child: Icon(Icons.fastfood),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar,
      floatingActionButton: _floatingActionButton,
      drawer: _drawer(context),
      appBar: _appBar,
      body: _homePageBody(noteList),
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: Text(
        'Home',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.invert_colors),
            onPressed: () {
              if (_isLightTheme) {
                ThemeSwitcher.of(context).switchTheme(darkTheme);
                _isLightTheme = false;
              } else {
                ThemeSwitcher.of(context).switchTheme(lightTheme);
                _isLightTheme = true;
              }
            },
          ),
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

  Widget _homePageBody(List<NotePage> noteList) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: noteList.length,
      itemBuilder: (context, index) => ListTile(
        title: noteList[index].title,
        leading: IconButton(
          icon: noteList[index].icon,
          iconSize: 35,
          onPressed: () => _openEventPage(index),
        ),
        subtitle: _listTileSubtitle(index),
        onTap: () => _openEventPage(index),
        onLongPress: () => _showBottomSheet(context, index),
      ),
    );
  }

  Text _listTileSubtitle(var index) {
    if (noteList[index].eventList.isEmpty) {
      return Text('No events. Click to create one.');
    } else {
      return Text(
          '${noteList[index].eventList[0].text}  ${noteList[index].eventList[0].time}');
    }
  }

  void _showBottomSheet(BuildContext context, var index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 120,
            child: _bottomSheetMenu(index),
          );
        });
  }

  void _editEvent(var index) async {
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
  }

  Column _bottomSheetMenu(var index) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.edit,
            color: Theme.of(context).accentColor,
          ),
          onTap: () => _editEvent(index),
          title: Text(
            'Edit event',
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: Text(
            'Delete event',
          ),
          onTap: () {
            setState(() {
              noteList.removeAt(index);
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _openEventPage(var index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventPage(
          title: noteList[index].title,
          notePage: noteList[index],
        ),
      ),
    );
    setState(() {});
  }

  BottomNavigationBar get _bottomNavigationBar {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_rounded),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      selectedFontSize: 15,
      unselectedFontSize: 15,
      showUnselectedLabels: true,
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Sized box to change the drawer header height.
          SizedBox(
            height: 120,
            child: DrawerHeader(
              child: ListTile(
                title: Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Item 1',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              // Need to add realization!
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Item 2',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              // Need to add realization!
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
