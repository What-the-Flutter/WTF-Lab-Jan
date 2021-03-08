import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/app_tab.dart';
import '../../theme/theme_bloc.dart';


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
      fixedColor: BlocProvider.of<ThemeBloc>(context).state == ThemeMode.dark
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
            color: BlocProvider.of<ThemeBloc>(context).state == ThemeMode.dark
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
