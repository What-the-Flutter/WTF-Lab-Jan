import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

import '../../icons.dart';
import '../../note.dart';
import '../../theme/cubit_theme.dart';
import '../create_page/create_page.dart';
import '../event_page/event_page.dart';
import '../settings_page/settings_page.dart';
import '../statistic_page/statistics_page.dart';
import '../timeline_page/timeline_page.dart';
import 'cubit_home_page.dart';
import 'states_home_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Note> _noteList = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CubitHomePage>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitHomePage, StatesHomePage>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar,
          body: _homePageBody(state),
          floatingActionButton: _floatingActionButton(state),
          drawer: _drawer,
          bottomNavigationBar: _bottomNavigationBar,
        );
      },
    );
  }

  BottomNavigationBar get _bottomNavigationBar {
    return BottomNavigationBar(
      onTap: (value) {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: TimelinePage(),
          ),
        );
      },
      items: [
        BottomNavigationBarItem(
          backgroundColor: BlocProvider.of<CubitTheme>(context)
              .state
              .themeData
              ?.backgroundColor,
          icon: const Icon(
            Icons.home,
          ),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_view_day_sharp,
          ),
          label: 'Daily',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.timeline,
          ),
          label: 'TimeLine',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.explore,
          ),
          label: 'Explore',
        ),
      ],
      currentIndex: 0,
      showUnselectedLabels: true,
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
            child: const Text(
              'Information',
              style: TextStyle(
                fontSize: 45,
              ),
            ),
          ),
          GestureDetector(
            child: ListTile(
              leading: Container(
                height: 35,
                width: 35,
                child: BlocProvider.of<CubitTheme>(context).state.isLightTheme!
                    ? Lottie.network(
                        'https://assets4.lottiefiles.com/packages/lf20_hvxmoeqb.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                      )
                    : Lottie.network(
                        'https://assets5.lottiefiles.com/packages/lf20_i85votuf.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                      ),
              ),
              title: const Text('Profile'),
            ),
          ),
          GestureDetector(
            child: ListTile(
              leading: Container(
                height: 35,
                width: 35,
                child: BlocProvider.of<CubitTheme>(context).state.isLightTheme!
                    ? Lottie.network(
                        'https://assets10.lottiefiles.com/packages/lf20_6ctkb0oz.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                      )
                    : Lottie.network(
                        'https://assets4.lottiefiles.com/packages/lf20_nrjiwkxn.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                      ),
              ),
              title: const Text(
                'Settings',
                key: Key(
                  'settings',
                ),
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
          GestureDetector(
            child: ListTile(
              leading: Container(
                height: 35,
                width: 35,
                child: const Icon(Icons.multiline_chart),
              ),
              title: const Text('Statistics'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StatisticsPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton _floatingActionButton(StatesHomePage state) {
    return FloatingActionButton(
      child: BlocProvider.of<CubitTheme>(context).state.isLightTheme!
          ? Lottie.network(
              'https://assets4.lottiefiles.com/packages/lf20_kcywyypy.json',
              repeat: true,
              reverse: true,
              animate: true,
            )
          : Lottie.network(
              'https://assets7.lottiefiles.com/packages/lf20_u0sqq9uw.json',
              repeat: true,
              reverse: true,
              animate: true,
            ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreatePage(),
          ),
        );
      },
    );
  }

  ListView _homePageBody(StatesHomePage state) {
    return ListView.builder(
      itemCount: state.noteList.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) => _listTile(index, state),
    );
  }

  ListTile _listTile(int index, StatesHomePage state) {
    final _note = state.noteList[index];
    return ListTile(
      title: Text(
        _note.eventName,
      ),
      leading: CircleAvatar(
        radius: 25,
        child: iconsList[_note.indexOfCircleAvatar],
      ),
      subtitle: Text(
        _note.subTittleEvent,
      ),
      onTap: () async {
        await Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: EventPage(
              title: _note.eventName,
              note: _note,
              noteList: state.noteList,
            ),
          ),
        );
        BlocProvider.of<CubitHomePage>(context).setNoteList(state.noteList);
      },
      onLongPress: () => _showBottomSheet(index, state),
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: const Center(
        child: Text(
          'Home',
          key: Key('Home'),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => BlocProvider.of<CubitTheme>(context).changeTheme(),
          icon: const Icon(
            Icons.invert_colors,
          ),
        )
      ],
    );
  }

  void _showBottomSheet(int index, StatesHomePage state) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 120,
          child: _buildBottomNavigationMenu(index, state),
        );
      },
    );
  }

  Column _buildBottomNavigationMenu(int index, StatesHomePage state) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          title: const Text('Edit'),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePage(
                  note: state.noteList[index],
                ),
              ),
            );
            BlocProvider.of<CubitHomePage>(context)
                .updateNote(state.noteList[index]);
            BlocProvider.of<CubitHomePage>(context).setNoteList(state.noteList);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.delete,
            color: Colors.black,
          ),
          title: const Text('Delete'),
          onTap: () {
            BlocProvider.of<CubitHomePage>(context).deleteNote(index);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
