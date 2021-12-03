import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../icons.dart';
import '../../note.dart';
import '../event_page/event_page.dart';
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
    _noteList.add(
      Note(
        eventName: 'Travel',
        indexOfCircleAvatar: 0,
        subTittleEvent: 'Add event',
      ),
    );
    BlocProvider.of<CubitHomePage>(context).init(_noteList);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitHomePage, StatesHomePage>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar,
          body: _homePageBody(state),
          floatingActionButton: _floatingActionButton,
          drawer: _drawer,
          bottomNavigationBar: _bottomNavigationBar,
        );
      },
    );
  }

  BottomNavigationBar get _bottomNavigationBar {
    return BottomNavigationBar(
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      items: [
        const BottomNavigationBarItem(
          backgroundColor: Colors.deepPurple,
          icon: Icon(
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
                fontSize: 40,
              ),
            ),
          ),
          GestureDetector(
            child: const ListTile(
              leading: Icon(
                Icons.account_circle,
              ),
              title: Text('Profile'),
            ),
          ),
          GestureDetector(
            child: const ListTile(
              leading: Icon(
                Icons.settings,
              ),
              title: Text(
                'Settings',
              ),
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      child: const Icon(
        Icons.add,
      ),
      onPressed: () {},
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
        style: const TextStyle(
          fontSize: 27,
        ),
      ),
      leading: CircleAvatar(
        radius: 25,
        child: iconsList[_note.indexOfCircleAvatar],
      ),
      subtitle: Text(
        _note.subTittleEvent,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(
              title: _note.eventName,
              note: _note,
              noteList: state.noteList,
            ),
          ),
        );
      },
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: const Center(
        child: Text('Home'),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.invert_colors,
          ),
        )
      ],
    );
  }
}
