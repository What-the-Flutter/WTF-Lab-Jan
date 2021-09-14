import 'package:flutter/material.dart';

import 'event_page.dart';
import 'style.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundDecoration,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadiusBottom,
            ),
            leading: const Icon(Icons.menu_rounded),
            title: const Text('Home'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: null,
            backgroundColor: mainColor,
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    child: Text('Questionnaire Bot',
                        style: TextStyle(color: mainColor)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(markedMessageColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: borderRadius,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: _eventsList()),
              ],
            ),
          ),
          bottomNavigationBar: _bottomNavigationBar()),
    );
  }

  Widget _bottomNavigationBar() {
    return ClipRRect(
      borderRadius: borderRadiusTop,
      child: BottomNavigationBar(
        unselectedItemColor: unselectedIconColor,
        selectedItemColor: mainColor,
        iconSize: 27,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            title: Text('Daily'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in_rounded),
            title: Text('Timeline'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            title: Text('Explore'),
          ),
        ],
      ),
    );
  }

  Widget _eventsList() {
    var _eventTitles = [
      'Journal',
      'Notes',
      'Gratitude',
    ];
    var _eventIcons = [
      Icons.book_rounded,
      Icons.sticky_note_2_sharp,
      Icons.people_alt_rounded,
    ];
    return ListView.builder(
        itemCount: _eventTitles.length,
        itemBuilder: (context, i) => _event(_eventTitles[i], _eventIcons[i]));
  }

  Widget _event(String eventTitle, IconData? eventIcon) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        height: 70,
        child: ElevatedButton(
          style: ButtonStyle(
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            backgroundColor:
                MaterialStateProperty.all<Color>(eventBackgroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventPage()),
            );
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Icon(
                  eventIcon,
                  color: eventIconColor,
                  size: 40,
                ),
              ),
              Text(
                eventTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
