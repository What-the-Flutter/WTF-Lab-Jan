import 'package:flutter/material.dart';

import '../../config/custom_theme.dart';
import '../../constants/themes.dart';
import 'components/notes_list.dart';
import 'components/questionnaire_bot.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  MyThemeKeys themeKey;
  bool themeChanged = false;

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      drawer: drawer(context),
      appBar: appBar(),
      body: body(size),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  SingleChildScrollView body(Size size) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          QuestionnaireBot(),
          NotesList(size: size),
        ],
      ),
    );
  }

  Drawer drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text('Item 3'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: Text('Home'),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      actions: [
        IconButton(
          icon: Icon(
            Icons.invert_colors,
          ),
          onPressed: () {
            themeChanged = !themeChanged;
            if (themeChanged == true) {
              themeKey = MyThemeKeys.dark;
            } else {
              themeKey = MyThemeKeys.light;
            }
            _changeTheme(context, themeKey);
          },
        ),
      ],
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      backgroundColor: Theme.of(context).primaryColorLight,
      selectedItemColor: Theme.of(context).buttonColor,
      unselectedItemColor: Colors.blueGrey,
      elevation: 1.0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline_outlined),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: 'Explore',
        ),
      ],
      onTap: (index) => setState(() => _currentIndex = index),
    );
  }
}
