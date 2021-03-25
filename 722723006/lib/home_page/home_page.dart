import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_page/settings/settings_page.dart';
import '../data/db_provider.dart';
import '../data/shared_preferences_provider.dart';
import '../event_page/event_page.dart';
import '../icon_list.dart';
import '../note_page/note.dart';
import '../note_page/note_page.dart';
import '../theme/dark_theme.dart';
import '../theme/light_theme.dart';
import '../theme/theme.dart';
import 'home_page_cubit.dart';

class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final List<Note> noteList = <Note>[];
  final DBProvider _dbProvider = DBProvider();
  final HomePageCubit _cubit = HomePageCubit(
    HomePageStates(
      noteList: noteList,
      isThemeChange: SharedPreferencesProvider().fetchTheme(),
    ),
  );

  @override
  void initState() {
    _dbProvider.initDatabase();
    _cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          drawer: _drawer,
          body: _homePageBody(),
          appBar: _appBar,
          bottomNavigationBar: _bottomNavigationBar,
          floatingActionButton: _floatingActionButton,
        );
      },
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
            _cubit.state.isThemeChange
                ? ThemeSwitcher.of(context).switchTheme(darkTheme)
                : ThemeSwitcher.of(context).switchTheme(lightTheme);
            _cubit.setThemeChangeState(!_cubit.state.isThemeChange);
          },
        ),
      ],
    );
  }

  ListView _homePageBody() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _cubit.state.noteList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(_cubit.state.noteList[index].noteName),
        leading: IconButton(
          icon: CircleAvatar(
            child:
                listOfIcons[_cubit.state.noteList[index].indexOfCircleAvatar],
          ),
          iconSize: 40,
          onPressed: () {},
        ),
        subtitle: Text(_cubit.state.noteList[index].subTittleEvent),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventPage(
                title: _cubit.state.noteList[index].noteName,
                note: _cubit.state.noteList[index],
                noteList: _cubit.state.noteList,
              ),
            ),
          );
          _cubit.updateNote(_cubit.state.noteList[index]);
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
                  note: _cubit.state.noteList[index],
                ),
              ),
            );
            _cubit.updateNote(_cubit.state.noteList[index]);
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
            _cubit.deleteNote(_cubit.state.noteList, index);
            Navigator.pop(context);
          },
        ),
      ],
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
            child: Text('Notifications'),
          ),
          ListTile(
            title: Text('Search'),
            leading: Icon(Icons.search),
          ),
          ListTile(
            title: Text('Notifications'),
            leading: Icon(Icons.notifications),
          ),
          ListTile(
            title: Text('Statistics'),
            leading: Icon(Icons.timeline),
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Feedback'),
            leading: Icon(Icons.mail),
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
              noteList: _cubit.state.noteList,
            ),
          ),
        );
        _cubit.updateList(_cubit.state.noteList);
      },
      child: Icon(Icons.add),
    );
  }
}
