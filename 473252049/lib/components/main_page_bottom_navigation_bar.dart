import 'package:flutter/material.dart';

class MainPageBottomNavigationBar extends StatelessWidget {
  final int currentPageIndex;
  final void Function(int) onTabTap;

  MainPageBottomNavigationBar(this.currentPageIndex, this.onTabTap);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentPageIndex,
      onTap: onTabTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.paste),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
    );
  }
}
