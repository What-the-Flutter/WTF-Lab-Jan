import 'package:flutter/material.dart';
import "package:hovering/hovering.dart";

var mainColor = Color(0xFF173E47);

void main() {
  runApp(MyApp());
}

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFEFF7FA), Color(0xFFF7F1FC)]),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
              leading: Icon(Icons.menu_rounded),
              title: Text('Home'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: null,
              backgroundColor: mainColor,
              child: Icon(Icons.add),
            ),
            body: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: null,
                            child: Text('Questionnaire Bot'),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))))),
                    Expanded(child: _eventsList()),
                  ],
                )),
            bottomNavigationBar: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: BottomNavigationBar(
                  backgroundColor: mainColor,
                  unselectedItemColor: Color(0xFFE5E0EF),
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
                ))));
  }

  Widget _event(String eventTitle, IconData? eventIcon) {
    return HoverContainer(
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      height: 70,
      hoverMargin: EdgeInsets.all(5),
      child: Row(children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Icon(
            eventIcon,
            color: Color(0xFFF0F4FA),
            size: 40,
          ),
        ),
        Text(
          eventTitle,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: mainColor, fontSize: 15),
        ),
      ]),
    );
  }

  Widget _eventsList() {
    var _eventTitles = ['Journal', 'Notes', 'Gratitude'];
    var _eventIcons = [
      Icons.book_rounded,
      Icons.sticky_note_2_sharp,
      Icons.people_alt_rounded
    ];
    return ListView.builder(
        itemCount: _eventTitles.length,
        itemBuilder: (context, i) {
          return _event(_eventTitles[i], _eventIcons[i]);
        });
  }
}
