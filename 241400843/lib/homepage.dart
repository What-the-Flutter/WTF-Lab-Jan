import 'package:flutter/material.dart';
import 'createnewpage.dart';
import 'eventpage.dart';
import 'theme.dart';

class Notes {
  IconData notesIcon;
  String notesTitle;
  String notesSubtitle;

  Notes({this.notesIcon, this.notesTitle, this.notesSubtitle});
}

List<Notes> notes = [
  Notes(
      notesIcon: Icons.airport_shuttle,
      notesTitle: 'First ',
      notesSubtitle: 'Something about fisrt'),
  Notes(
      notesIcon: Icons.airplanemode_active,
      notesTitle: 'Second ',
      notesSubtitle: 'Something about second'),
  Notes(
      notesIcon: Icons.bike_scooter,
      notesTitle: 'Third',
      notesSubtitle: 'Something about third'),
];

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool selected = true;

  Future<void> _showEditingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text('Edit Page'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateNewPage(
                              // isEditing: true,

                              ),
                        ),
                      );
                    },
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  GestureDetector(
                    child: Text('Delete Page'),
                    onTap: () {
                      notes.remove(Notes());
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Home'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: 'Settings',
            icon: (selected)
                ? Icon(
                    Icons.brightness_1_outlined,
                  )
                : Icon(
                    Icons.bedtime,
                  ),
            onPressed: () {
              AppTheme.of(context).changeTheme();
              setState(() {
                selected = !selected;
              });
            },
          ),
        ],
      ),
      body: _homePageBody(notes),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateNewPage(
                // isEditing: false,
                ),
          ));
        },
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
        key: Key(notes[index].toString()),
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
          _showEditingDialog(context);
        },
      ),
    );
  }
}
