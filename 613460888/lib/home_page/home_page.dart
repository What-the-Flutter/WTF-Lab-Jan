import 'package:flutter/material.dart';

import '../create_page/create_page.dart';
import '../event_page/event_page.dart';
import '../note_page/note.dart';
import '../themes/dark_theme.dart';
import '../themes/light_theme.dart';
import '../themes/theme_switcher.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final darkThemeData = darkTheme;
  final lightThemeData = lightTheme;
  bool _isLightTheme = true;

  final List<Note> noteList = [
    Note(
      'Travel',
      Icons.flight_takeoff_rounded,
      'No Events. Click to create one.',
    ),
    Note(
      'Family',
      Icons.family_restroom,
      'No Events. Click to create one.',
    ),
    Note(
      'Sports',
      Icons.sports_basketball,
      'No Events. Click to create one.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.title),
        ),
        actions: [
          IconButton(
            icon: (_isLightTheme)
                ? const Icon(Icons.brightness_2_outlined)
                : const Icon(Icons.brightness_2_rounded),
            onPressed: () {
              if (_isLightTheme) {
                ThemeSwitcher.of(context).switchTheme(darkThemeData);
                _isLightTheme = false;
              } else {
                ThemeSwitcher.of(context).switchTheme(lightThemeData);
                _isLightTheme = true;
              }
            },
          ),
        ],
      ),
      drawer: _drawer,
      body: _homePageBody,
      bottomNavigationBar: _bottomNavBar,
      floatingActionButton: _floatingActionButton,
    );
  }

  Drawer get _drawer {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Side navigation'),
            decoration: BoxDecoration(),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Scaffold get _homePageBody {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(60.0, 70.0),
        child: RawMaterialButton(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: (_isLightTheme)
                    ? Colors.lightGreenAccent
                    : Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.android,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Questionnaire Bot',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onPressed: () {},
        ),
      ),
      body: _eventsList(),
    );
  }

  ListView _eventsList() {
    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  width: 2,
                  color: (_isLightTheme)
                      ? Colors.deepPurple
                      : Colors.white70,
                ),
              ),
              child: Icon(
                noteList[index].iconData,
                size: 30,
              ),
            ),
            title: Text(
              noteList[index].eventName,
              style: TextStyle(
                color: (_isLightTheme)
                    ? Colors.black
                    : Colors.yellow,
              ),
            ),
            subtitle: Text(
              'No Events. Click to create one.',
              style: TextStyle(),
            ),
          ),
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
          onLongPress: () {
            _showBottomSheet(context, index);
          },
        );
      },
    );
  }

  BottomNavigationBar get _bottomNavBar {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
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
      currentIndex: selectedIndex,
      showUnselectedLabels: true,
    );
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePage(
              isEditing: false,
              noteList: noteList,
            ),
          ),
        );
        setState(() {});
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
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
          ),
          title: Text('Edit Event'),
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
            color: Colors.red,
          ),
          title: Text('Delete Event'),
          onTap: () {
            setState(
              () {
                noteList.removeAt(index);
                Navigator.pop(context);
              },
            );
          },
        ),
      ],
    );
  }
}
