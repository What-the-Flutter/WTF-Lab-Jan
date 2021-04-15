import 'package:flutter/material.dart';
import '../../../config/custom_theme.dart';
import '../../../constants/themes.dart';

import '../../../core/models/event_type.dart';
import '../../../core/services/db/db_helper.dart';
import '../../shared/widgets/bottom_nav_bar_item.dart';
import 'screens/events_type_add_screen.dart';
import 'widgets/event_type_list.dart';
import 'widgets/widget_bot.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  DBProvider db;
  MyThemeKeys themeKey;
  bool themeChanged = false;
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
        ),
        centerTitle: true,
        leading: Icon(
          Icons.menu,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.opacity,
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
      ),
      body: Column(
        children: [
          questionnaireBot(context),
          Divider(),
          eventTypeList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () async {
          Navigator.pushNamed(
            context,
            EventTypeAdd.routeName,
            arguments: EventType(
              icon: 'Unknown',
            ),
          ).whenComplete(
            () => setState(() {}),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme: IconThemeData(
          color: Colors.grey,
        ),
        items: [
          bottomNavBarItem(
            label: 'Home',
            icon: Icons.class_,
          ),
          bottomNavBarItem(
            label: 'Daily',
            icon: Icons.assignment,
          ),
          bottomNavBarItem(
            label: 'Timeline',
            icon: Icons.map,
          ),
          bottomNavBarItem(
            label: 'Explore',
            icon: Icons.explore,
          ),
        ],
      ),
    );
  }
}
