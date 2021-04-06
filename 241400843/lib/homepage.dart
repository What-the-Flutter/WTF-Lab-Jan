import 'package:flutter/material.dart';
import 'eventpage.dart';

class Notes {
  IconData notesIcon;
  String notesTitle;
  String notesSubtitle;

  Notes(this.notesIcon, this.notesTitle, this.notesSubtitle);
}

List<Notes> notes = [
  Notes(Icons.airport_shuttle, 'First ', 'Something about fisrt'),
  Notes(Icons.airplanemode_active, 'Second ', 'Something about second'),
  Notes(Icons.bike_scooter, 'Third', 'Something about third'),
];

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Something'),
              decoration: BoxDecoration(
                color: Colors.red[400],
              ),
            ),
            ListTile(title: Text('Menu 1'), onTap: () {}),
            ListTile(title: Text('Menu 2'), onTap: () {})
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: 'Settings',
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Settings'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is settings page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      body: _homePageBody(notes),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add 1 more event',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          )
        ],
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _homePageBody(List<Notes> notes) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: notes.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(
          notes[index].notesTitle,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Amatic_SC',
          ),
        ),
        leading: IconButton(
          icon: CircleAvatar(
            child: Icon(notes[index].notesIcon),
          ),
          iconSize: 30.0,
          padding: const EdgeInsets.all(4.0),
          onPressed: () {},
        ),
        subtitle: Text(
          notes[index].notesSubtitle,
          style: TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.italic,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => EventPage()),
          );
        },
        onLongPress: () {
          // showDialog(context: context, builder: builder);
        },
      ),
    );
  }
}
