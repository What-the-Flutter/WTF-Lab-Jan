import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lesson_1/themes/shared_preferences_provider.dart';

import '../create_page/create_page.dart';
import '../event_page/event_page.dart';
import '../note_page.dart';
import '../themes/dark_theme.dart';
import '../themes/light_theme.dart';
import '../themes/theme_switcher.dart';
import '../utils/database.dart';
import '../utils/icons.dart';
import 'cubit_home_page.dart';
import 'states_home_page.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  final DatabaseProvider _databaseProvider = DatabaseProvider();
  final CubitHomePage _cubit =
      CubitHomePage(StatesHomePage(SharedPreferencesProvider().fetchTheme()));

  @override
  void initState() {
    _databaseProvider.initDB();
    _cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: _bottomNavigationBar,
          floatingActionButton: _floatingActionButton,
          drawer: _drawer(context),
          appBar: _appBar,
          body: _homePageBody(_cubit.state.noteList),
        );
      },
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
              if (_cubit.state.isLightTheme) {
                ThemeSwitcher.of(context).switchTheme(darkThemeData);
              } else {
                ThemeSwitcher.of(context).switchTheme(lightThemeData);
              }
              _cubit.changeTheme();
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
              noteList: _cubit.state.noteList,
              isEditing: false,
            ),
          ),
        );
        _cubit.noteListRedrawing();
      },
    );
  }

  Widget _homePageBody(List<NotePage> noteList) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: noteList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(
          noteList[index].title,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: CircleAvatar(
            child: Icon(icons[_cubit.state.noteList[index].circleAvatarIndex]),
          ),
          iconSize: 35,
          onPressed: () => _openEventPage(index),
        ),
        subtitle: Text(
          _cubit.state.noteList[index].subtitle,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        onTap: () => _openEventPage(index),
        onLongPress: () => _showBottomSheet(context, index),
      ),
    );
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
          noteList: _cubit.state.noteList,
          index: index,
        ),
      ),
    );
    _cubit.noteListRedrawing();
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
            _cubit.removeNote(index);
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
          note: _cubit.state.noteList[index],
          noteList: _cubit.state.noteList,
        ),
      ),
    );
    _cubit.noteListRedrawing();
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
