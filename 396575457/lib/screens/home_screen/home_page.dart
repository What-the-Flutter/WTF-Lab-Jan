import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'events_title_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _sectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    var bottomBar = BottomNavigationBar(
      selectedItemColor: Colors.blue,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.blue),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dialpad, color: Colors.blue),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline, color: Colors.blue),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore, color: Colors.blue),
          label: 'Explore',
        ),
      ],
      currentIndex: _sectionIndex,
      onTap: (index) {
        setState(() {
          _sectionIndex = index;
        });
      },
    );

    return DefaultTabController(
      length: 1,
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border(
                    top: BorderSide(width: 2, color: Colors.white),
                  ),
                ),
                child: Center(
                  child: RaisedButton(
                    color: Colors.indigoAccent,
                    onPressed: null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.android),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        Text('Questionnaire Bot')
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
              ),
            ]),
            title: Center(
              child: Text('Home'),
            ),
            leading: IconButton(
                icon: Icon(
                  Icons.list,
                  color: Colors.white,
                ),
                onPressed: null),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.invert_colors, color: Colors.white),
                  onPressed: null),
            ],
          ),
          body: EventsTitleList(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.yellow,
            onPressed: null,
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
          bottomNavigationBar: bottomBar),
    );
  }
}
