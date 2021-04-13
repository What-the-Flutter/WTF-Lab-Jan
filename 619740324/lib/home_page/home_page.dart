import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../create_page/create_page.dart';
import '../create_page/icons.dart';
import '../data/shared_preferences_provider.dart';
import '../event_page/event_page.dart';
import '../note.dart';
import '../settings/settings_page.dart';
import '../theme/cubit_theme.dart';
import 'cubit_home_page.dart';
import 'states_home_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final List<Note> _noteList = <Note>[];
  final CubitHomePage _cubit = CubitHomePage(
    StatesHomePage(
      noteList: _noteList,
      isLightTheme: SharedPreferencesProvider().fetchTheme(),
    ),
  );

  @override
  void initState() {
    _cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitHomePage, StatesHomePage>(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: _floatingActionButton,
          appBar: _appBar,
          drawer: _drawer,
          bottomNavigationBar: _bottomNavigationBar,
          body: _homePageBody(),
        );
      },
    );
  }

  ListView _homePageBody() {
    return ListView.builder(
      itemCount: _cubit.state.noteList.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) => ListTile(
        title: Text(_cubit.state.noteList[index].eventName),
        leading: IconButton(
          icon: CircleAvatar(
            child: listIcons[_cubit.state.noteList[index].indexOfCircleAvatar],
          ),
          iconSize: 50,
          onPressed: () {},
        ),
        subtitle: Text(_cubit.state.noteList[index].subTittleEvent),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventPage(
                title: _cubit.state.noteList[index].eventName,
                note: _cubit.state.noteList[index],
                noteList: _cubit.state.noteList,
              ),
            ),
          );
          _cubit.redrawingList();
        },
        onLongPress: () => _showBottomSheet(context, index),
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
          GestureDetector(
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
          ),
          GestureDetector(
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
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
            BlocProvider.of<CubitTheme>(context).changeTheme();
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
              noteList: _cubit.state.noteList,
              isEditing: false,
            ),
          ),
        );
        _cubit.redrawingList();
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
                  noteList: _cubit.state.noteList,
                  index: index,
                ),
              ),
            );
            _cubit.updateNote(_cubit.state.noteList[index]);
            _cubit.redrawingList();
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
            _cubit.deleteNote(_cubit.state.noteList, index);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
