import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lesson_1/timeline_page/timeline_page.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../create_page/create_page.dart';
import '../event_page/event_page.dart';
import '../settings/settings_page.dart';
import '../themes/cubit_theme.dart';
import '../utils/icons.dart';
import 'cubit_home_page.dart';
import 'states_home_page.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<CubitHomePage>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitHomePage, StatesHomePage>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: _bottomNavigationBar,
          floatingActionButton: _floatingActionButton(state),
          drawer: _drawer(context),
          appBar: _appBar(state),
          body: _homePageBody(state),
        );
      },
    );
  }

  AppBar _appBar(StatesHomePage state) {
    return AppBar(
      title: Text(
        'Home',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.invert_colors),
            onPressed: () => BlocProvider.of<CubitTheme>(context).changeTheme(),
          ),
        ),
      ],
    );
  }

  FloatingActionButton _floatingActionButton(StatesHomePage state) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePage(
              noteList: state.noteList,
              isEditing: false,
            ),
          ),
        );
        BlocProvider.of<CubitHomePage>(context).noteListRedrawing();
      },
    );
  }

  Widget _homePageBody(StatesHomePage state) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: state.noteList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(
          state.noteList[index].title,
        ),
        leading: IconButton(
          icon: CircleAvatar(
            child: Icon(icons[state.noteList[index].circleAvatarIndex]),
          ),
          iconSize: 35,
          onPressed: () => _openEventPage(state, index),
        ),
        subtitle: Text(
          state.noteList[index].subtitle,
        ),
        onTap: () => _openEventPage(state, index),
        onLongPress: () => _showBottomSheet(state, context, index),
      ),
    );
  }

  void _showBottomSheet(StatesHomePage state, BuildContext context, var index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 120,
          child: _bottomSheetMenu(state, index),
        );
      },
    );
  }

  void _editEvent(StatesHomePage state, var index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePage(
          isEditing: true,
          noteList: state.noteList,
          index: index,
        ),
      ),
    );
    BlocProvider.of<CubitHomePage>(context).noteListRedrawing();
    Navigator.pop(context);
  }

  Column _bottomSheetMenu(StatesHomePage state, var index) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.edit,
            color: Theme.of(context).accentColor,
          ),
          onTap: () => _editEvent(state, index),
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
            BlocProvider.of<CubitHomePage>(context).removeNote(index);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _openEventPage(StatesHomePage state, var index) async {
    await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: EventPage(
          note: state.noteList[index],
          noteList: state.noteList,
        ),
      ),
    );
    BlocProvider.of<CubitHomePage>(context).noteListRedrawing();
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
        children: <Widget>[
          SizedBox(
            height: 110,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: ListTile(
                title: Text(
                  DateFormat.yMMMMd('en_US').format(DateTime.now()),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            child: _listTile(Icons.search, 'Search'),
            onTap: () {
              //TODO
            },
          ),
          GestureDetector(
            child: _listTile(Icons.insert_chart, 'Statistics'),
            onTap: () {
              //TODO
            },
          ),
          GestureDetector(
            child: _listTile(Icons.notifications, 'Notifications'),
            onTap: () {
              //TODO
            },
          ),
          GestureDetector(
            child: _listTile(Icons.settings, 'Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
          GestureDetector(
            child: _listTile(Icons.mail, 'Feedback'),
            onTap: () {
              //TODO
            },
          ),
        ],
      ),
    );
  }

  ListTile _listTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon,
        size: 25,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
      ),
    );
  }
}
