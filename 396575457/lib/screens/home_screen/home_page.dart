import 'package:diary_in_chat_format_app/screens/home_screen/event_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _sectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    var bottomBar = BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.blue),
            title: Text(
              'Home',
              style: TextStyle(color: Colors.blue),
            )),
        BottomNavigationBarItem(
            icon: Icon(Icons.dialpad, color: Colors.blue),
            title: Text(
              'Daily',
              style: TextStyle(color: Colors.blue),
            )),
        BottomNavigationBarItem(
            icon: Icon(Icons.timeline, color: Colors.blue),
            title: Text(
              'Timeline',
              style: TextStyle(color: Colors.blue),
            )),
        BottomNavigationBarItem(
            icon: Icon(Icons.explore, color: Colors.blue),
            title: Text(
              'Explore',
              style: TextStyle(color: Colors.blue),
            )),
      ],
      currentIndex: _sectionIndex,
      onTap: (int index) {
        setState(() {
          _sectionIndex = index;
        });
      },
    );

    return Container(
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Container(
                  decoration: new BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border:
                      Border(top: BorderSide(width: 2, color: Colors.white))),
                  child: Center(child: RaisedButton(
                      color: Colors.indigoAccent,
                      onPressed: () {
                        print('sth');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.android),
                          Padding(padding: EdgeInsets.all(10),),
                          Text('Questionnaire Bot')],
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),)
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
          body: EventsList(),
          //_sectionIndex == 0 ?
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.yellow,
              onPressed: null,
              child: Icon(
                Icons.add,
                color: Colors.black,
              )),
          bottomNavigationBar: bottomBar),
    );
  }
}
