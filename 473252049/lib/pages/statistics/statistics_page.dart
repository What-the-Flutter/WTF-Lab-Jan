import 'package:flutter/material.dart';

import 'tabs/categories_statistics_tab.dart';
import 'tabs/categories_statistics_tab_view.dart';
import 'tabs/time_statistics_tab.dart';
import 'tabs/time_statistics_tab_view.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
          bottom: TabBar(
            tabs: [
              CategoriesStatisticsTab(),
              TimeStatisticsTab(),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CategoriesStatisticsTabView(),
            TimeStatisticsTabView(),
          ],
        ),
      ),
    );
  }
}
