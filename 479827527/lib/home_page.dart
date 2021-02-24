import 'package:flutter/material.dart';

import 'event_page.dart';
import 'note_page.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  final List<NotePage> noteList = [
    NotePage(
      Text(
        'Travel',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Text(
        'No events. Click to create one.',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      CircleAvatar(
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.airplanemode_active,
          color: Colors.white,
        ),
      ),
    ),
    NotePage(
      Text(
        'Family',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Text(
        'No events. Click to create one.',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      CircleAvatar(
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.family_restroom,
          color: Colors.white,
        ),
      ),
    ),
    NotePage(
      Text(
        'Sports',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Text(
        'No events. Click to create one.',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      CircleAvatar(
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.fitness_center_rounded,
          color: Colors.white,
        ),
      ),
    ),
    NotePage(
      Text(
        'Food',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Text(
        'No events. Click to create one.',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      CircleAvatar(
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.fastfood,
          color: Colors.white,
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar,
      floatingActionButton: _floatingActionButton,
      drawer: _drawer(context),
      appBar: _appBar,
      body:_homePageBody(noteList),
    );
  }
}

FloatingActionButton get _floatingActionButton {
  return FloatingActionButton(
    child: Icon(Icons.add),
    backgroundColor: Color.fromRGBO(30, 144, 255, 100),
    onPressed: () {
      // Update state
    },
  );
}

AppBar get _appBar {
  return AppBar(
    backgroundColor: Colors.deepPurple,
    title: Text(
      'Home',
      style: TextStyle(
        fontSize: 20,
      ),
    ),
    centerTitle: true,
    actions: <Widget>[
      Padding(
        padding: EdgeInsets.only(right: 20),
        child: GestureDetector(
          onTap: () {
            // Update state
          },
          child: Icon(Icons.invert_colors),
        ),
      ),
    ],
  );
}

Widget _homePageBody(List<NotePage> noteList) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    itemCount: noteList.length,
    itemBuilder: (context, index) =>
        ListTile(
          title: noteList[index].title,
          leading: IconButton(
            icon: noteList[index].icon,
            onPressed: () {},
          ),
          subtitle: noteList[index].subtitle,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventPage(
                      title: noteList[index].title,
                      notePage: noteList[index],
                  ),
              ),
            );
          },
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
    selectedItemColor: Colors.deepPurple,
    selectedFontSize: 15,
    unselectedItemColor: Colors.grey,
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
                  color: Colors.white,
                ),
              ),
            ),
            decoration: BoxDecoration(color: Colors.deepPurple),
          ),
        ),
        ListTile(
          title: Text(
            'Item 1',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
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
              color: Colors.black,
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

