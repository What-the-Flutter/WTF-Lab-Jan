import 'package:chat_journal_wtf/event_page/event_page.dart';
import 'package:chat_journal_wtf/note_page/note.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool isPressed = false;
  final List<Note> noteList = [
    Note(
      'Travel',
      Icons.flight_takeoff_rounded,
      'No Events. Click to create one.',
    ),
    Note(
      'Family',
      Icons.family_restroom,
      'No Events. Click to create one.',
    ),
    Note(
      'Sports',
      Icons.sports_basketball,
      'No Events. Click to create one.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: (isPressed)
            ? Colors.black
            : Colors.deepPurple,
        title: Center(
          child: Text(widget.title),
        ),
        actions: [
          IconButton(
            icon: (isPressed)
                ? const Icon(Icons.brightness_2_rounded)
                : const Icon(Icons.brightness_2_outlined),
            onPressed: () {
              if (isPressed == false) {
                setState(() => isPressed = true);
              } else {
                setState(() => isPressed = false);
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Side navigation'),
              decoration: BoxDecoration(
                color: (isPressed)
                    ? Colors.black54
                    : Colors.lightGreen,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Scaffold(
        backgroundColor: (isPressed)
            ? Colors.black54
            : Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size(60.0, 70.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: (isPressed)
                    ? Colors.purpleAccent
                    : Colors.lightGreenAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.android,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Questionnaire Bot',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: noteList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 2,
                      color: (isPressed)
                          ? Colors.purpleAccent
                          : Colors.deepPurple,
                    ),
                  ),
                  child: Icon(
                    noteList[index].iconData,
                    size: 30,
                    color: (isPressed)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                title: Text(
                  noteList[index].eventName,
                  style: TextStyle(
                    color: (isPressed)
                        ? Colors.white70
                        : Colors.black,
                  ),
                ),
                subtitle: Text(
                  'No Events. Click to create one.',
                  style: TextStyle(
                    color: (isPressed)
                        ? Colors.white60
                        : Colors.black54,
                  ),
                ),
              ),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventPage(
                      title: noteList[index].eventName,
                      note: noteList[index],
                    ),
                  ),
                ),
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          )
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: (isPressed) 
            ? Colors.white
            : Colors.black,
        showUnselectedLabels: true,
        backgroundColor: (isPressed)
            ? Colors.black
            : Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: (isPressed)
            ? Colors.black
            : Colors.deepPurple,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
