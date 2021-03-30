import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../event_page/event_page.dart';
import '../icon_list.dart';
import '../note_page/note.dart';
import '../note_page/note_page.dart';
import '../settings/settings_page.dart';
import '../theme/theme_cubit.dart';
import 'home_page_cubit.dart';

class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final List<Note> _noteList = <Note>[];
  final HomePageCubit _cubit = HomePageCubit(
    HomePageStates(
      noteList: _noteList,
    ),
  );

  @override
  void initState() {
    _cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageStates>(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          drawer: _drawer,
          body: _homePageBody(state),
          appBar: _appBar,
          bottomNavigationBar: _bottomNavigationBar,
          floatingActionButton: _floatingActionButton(
            state,
          ),
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
            BlocProvider.of<ThemeCubit>(context).changeTheme();
          },
        ),
      ],
    );
  }

  ListView _homePageBody(HomePageStates state) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: state.noteList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(state.noteList[index].noteName),
        leading: IconButton(
          icon: CircleAvatar(
            child: listOfIcons[state.noteList[index].indexOfCircleAvatar],
          ),
          iconSize: 40,
          onPressed: () {},
        ),
        subtitle: Text(state.noteList[index].subTittleEvent),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventPage(
                title: state.noteList[index].noteName,
                note: state.noteList[index],
                noteList: state.noteList,
              ),
            ),
          );
          _cubit.updateNote(state.noteList[index]);
        },
        onLongPress: () => _showBottomSheet(context, index, state),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, int index, HomePageStates state) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 170,
          child: _buildBottomNavigationMenu(index, state),
        );
      },
    );
  }

  Column _buildBottomNavigationMenu(int index, HomePageStates state) {
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
                  note: state.noteList[index],
                ),
              ),
            );
            _cubit.updateNote(state.noteList[index]);
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
            _cubit.deleteNote(state.noteList, index);
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
          SizedBox(
            height: 145,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ListTile(
                  title: Text(
                    DateFormat.yMMMd('en_US').format(
                      DateTime.now(),
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                    ),
                  ),
                  subtitle: Text(
                    '(Click here to setup Drive backups)',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
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

  FloatingActionButton _floatingActionButton(HomePageStates state) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotePage(
              noteList: state.noteList,
            ),
          ),
        );
        _cubit.updateList(state.noteList);
      },
      child: Icon(Icons.add),
    );
  }
}
