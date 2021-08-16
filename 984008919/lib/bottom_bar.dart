import 'package:flutter/material.dart';
import 'package:flutter_app_chat_journal/main.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _index = 0;
  List<Widget> _widget = <Widget>[
    MyHomePage(),
    Text('2'),
    Text('3'),
    Text('4'),
  ];

  void _onItemTap(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.teal,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_rounded),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        )
      ],
      onTap: _onItemTap,
    );
  }
}
