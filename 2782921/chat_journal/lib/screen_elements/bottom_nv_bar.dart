import 'package:flutter/material.dart';

class BottomNavigationBarCustom extends StatefulWidget {
  BottomNavigationBarCustom({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarCustomState createState() =>
      _BottomNavigationBarCustomState();
}

class _BottomNavigationBarCustomState extends State<BottomNavigationBarCustom> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w300,
  );
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Daily',
      style: optionStyle,
    ),
    Text(
      'Index 2: Timeline',
      style: optionStyle,
    ),
    Text(
      'Index 4: Explore',
      style: optionStyle,
    ),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.night_shelter_outlined),
          label: 'Home',
          backgroundColor: Colors.indigo,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.map_rounded,
          ),
          label: 'Daily',
          backgroundColor: Colors.lightBlueAccent,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.insights_outlined,
          ),
          label: 'Timeline',
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.explore_rounded,
          ),
          label: 'Explore',
          backgroundColor: Colors.deepOrange,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      onTap: onItemTapped,
      unselectedItemColor: Colors.white,
    );
  }
}
