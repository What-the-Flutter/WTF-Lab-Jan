import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_tab.dart';
import '../theme_provider/custom_theme_provider.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      type: BottomNavigationBarType.fixed,
      fixedColor: Provider.of<ThemeProvider>(context).isDarkMode
          ? Theme.of(context).floatingActionButtonTheme.backgroundColor
          : Theme.of(context).scaffoldBackgroundColor,
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab == AppTab.home
                ? Icons.home_sharp
                : tab == AppTab.daily
                    ? Icons.assignment_outlined
                    : tab == AppTab.timeline
                        ? Icons.timeline
                        : Icons.explore,
            // key: tab == AppTab.todos
            //     ? ArchSampleKeys.todoTab
            //     : ArchSampleKeys.statsTab,
            color: Provider.of<ThemeProvider>(context).isDarkMode
                ? Theme.of(context).floatingActionButtonTheme.backgroundColor
                : Theme.of(context).scaffoldBackgroundColor,
          ),
          label: tab == AppTab.home
              ? 'Home'
              : tab == AppTab.daily
                  ? 'Daily'
                  : tab == AppTab.timeline
                      ? 'Timeline'
                      : 'Explore',
        );
      }).toList(),
    );
  }
}
