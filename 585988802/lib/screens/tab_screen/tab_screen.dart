import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/app_tab.dart';
import '../home_screen/home_screen.dart';
import '../summary_screen/summary_screen.dart';
import '../timeline_screen/timeline_screen.dart';
import 'tab_bloc.dart';
import 'tab_event.dart';
import 'tab_selector.dart';

class TabScreen extends StatefulWidget {
  TabScreen({Key key}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: activeTab == AppTab.home
              ? HomeScreen()
              : activeTab == AppTab.timeline
                  ? TimeLineScreen()
                  : SummaryScreen(),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) => BlocProvider.of<TabBloc>(context).add(
              TabUpdated(tab),
            ),
          ),
        );
      },
    );
  }
}
