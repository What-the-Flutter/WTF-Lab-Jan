import 'package:flutter/material.dart';

class BottomPanelTabs extends StatefulWidget {
  @override
  _BottomPanelTabsState createState() => _BottomPanelTabsState();
}

class _BottomPanelTabsState extends State<BottomPanelTabs> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(
            Icons.home,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Daily',
          icon: Icon(
            Icons.event_note_sharp,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Timeline',
          icon: Icon(
            Icons.timeline,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Explore',
          icon: Icon(
            Icons.explore,
          ),
        )
      ],
      onTap: (index) {
        setState(
          () => _currentIndex = index,
        );
      },
    );
  }
}
