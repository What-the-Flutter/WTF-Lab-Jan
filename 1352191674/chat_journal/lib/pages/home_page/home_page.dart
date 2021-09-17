import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../ui/theme_cubit/theme_cubit.dart';
import '../create_page/create_page.dart';
import '../events_page/event_page.dart';
import '../settings_page/settings_page.dart';
import '../statistics/statistics_page.dart';
import 'home_page_cubit.dart';

class HomePage extends StatefulWidget {
  final String? title;
  HomePage({Key? key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<HomePageCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(),
          drawer: _drawer(context),
          body: _homePageBody(state),
          floatingActionButton: _floatingActionButton(state),
        );
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Home',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.opacity,
          ),
          onPressed: () => BlocProvider.of<ThemeCubit>(context).changeTheme(),
        ),
      ],
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 10,
    );
  }

  Drawer _drawer(BuildContext context) {
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
                    style: TextStyle(fontSize: 20, color: Colors.white),
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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StatisticsPage(),
              ),
            ),
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ),
            ),
          ),
          ListTile(
            title: Text('Feedback'),
            leading: Icon(Icons.mail),
          ),
        ],
      ),
    );
  }

  ListView _homePageBody(HomePageState state) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: state.noteList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(state.noteList[index].noteName),
        leading: IconButton(
          icon: CircleAvatar(
            child: Icon(iconList[state.noteList[index].indexOfCircleAvatar]),
          ),
          iconSize: 40,
          onPressed: () {},
        ),
        subtitle: Text(state.noteList[index].subTitleEvent),
        onTap: () async {
          print('test');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventPage(
                title: state.noteList[index].noteName,
                note: state.noteList[index],
                noteList: state.noteList,
              ),
            ),
          );
        },
        onLongPress: () => _showBottomSheet(index, state),
      ),
    );
  }

  void _showBottomSheet(int index, HomePageState state) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 170,
          child: _bottomNavigationMenu(index, state),
        );
      },
    );
  }

  Widget _bottomNavigationMenu(int index, HomePageState state) {
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
            BlocProvider.of<HomePageCubit>(context)
                .updateNote(state.noteList[index]);
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
            BlocProvider.of<HomePageCubit>(context)
                .deleteNote(state.noteList, index);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _floatingActionButton(HomePageState state) {
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
        BlocProvider.of<HomePageCubit>(context).updateList(state.noteList);
      },
      child: Icon(Icons.add),
    );
  }
}
