import 'package:flutter/material.dart';

class BottomPanelTabs extends StatefulWidget {
  @override
  _BottomPanelTabsState createState() => _BottomPanelTabsState();
}

class _BottomPanelTabsState extends State<BottomPanelTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange[300],
      items: <BottomNavigationBarItem>[
        navigationBarItem('Home', Icons.book),
        navigationBarItem('Daily', Icons.assignment),
        navigationBarItem('Timeline', Icons.timeline),
        navigationBarItem('Explore', Icons.explore),
      ],
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem navigationBarItem(
      String bottomNavigationBarLabel, IconData bottomNavigationBarIcon) {
    return BottomNavigationBarItem(
      icon: Icon(
        bottomNavigationBarIcon,
        size: 30,
      ),
      label: bottomNavigationBarLabel,
    );
  }
}
