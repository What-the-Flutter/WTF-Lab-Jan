import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/app_tab.dart';

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
      fixedColor: Theme.of(context).indicatorColor,
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab == AppTab.home
                ? Icons.home_sharp
                : tab == AppTab.timeline
                    ? Icons.timeline
                    : Icons.insert_chart_outlined_sharp,
            color: Theme.of(context).indicatorColor,
          ),
          label: tab == AppTab.home
              ? 'Home'
              : tab == AppTab.timeline
                  ? 'Timeline'
                  : 'Summary',
        );
      }).toList(),
    );
  }
}
