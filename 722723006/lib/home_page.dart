import 'package:flutter/material.dart';

import 'event_page.dart';
import 'note.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Note> noteList = [
    Note(
        'Drinks',
        CircleAvatar(
          child: Icon(Icons.liquor),
        ),
        'Add event'),
    Note(
        'FastFood',
        CircleAvatar(
          child: Icon(Icons.fastfood),
        ),
        'Add event'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer,
      body: _homePageBody(noteList),
      appBar: _appBar,
      bottomNavigationBar: _bottomNavigationBar,
      floatingActionButton: _floatingActionButton,
    );
  }
}

AppBar get _appBar {
  return AppBar(
    title: Center(
      child: Text('Home'),
    ),
    actions: [
      IconButton(icon: Icon(Icons.invert_colors), onPressed: () {}),
    ],
  );
}

Widget _homePageBody(List<Note> noteList) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    itemCount: noteList.length,
    itemBuilder: (context, index) => ListTile(
      title: Text(noteList[index].eventName),
      leading: IconButton(
        icon: noteList[index].iconData,
        onPressed: () {},
      ),
      subtitle: Text(noteList[index].subTittleEvent),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventPage(
                      title: noteList[index].eventName,
                      note: noteList[index],
                    )));
      },
      onLongPress: () => _showBottomSheet(context, noteList[index]),
    ),
  );
}

void _showBottomSheet(BuildContext context, Note listViewSuggestions) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 170,
          child: _buildBottomNavigationMenu(),
        );
      });
}

Column _buildBottomNavigationMenu() {
  return Column(
    children: <Widget>[
      ListTile(
        leading: Icon(Icons.info_outline),
        title: Text('Info'),
      ),
      ListTile(
        leading: Icon(Icons.edit),
        title: Text('Edit'),
      ),
      ListTile(
        leading: Icon(Icons.delete),
        title: Text('Delete'),
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
            color: Colors.blue,
          ),
          child: Text('Profile'),
        ),
        ListTile(
          title: Text('Password'),
        ),
        ListTile(
          title: Text('Exit'),
        )
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
    unselectedItemColor: Colors.blueGrey,
    selectedItemColor: Colors.blue,
    showUnselectedLabels: true,
  );
}

FloatingActionButton get _floatingActionButton {
  return FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  );
}
