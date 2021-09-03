import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../categories/categories_page.dart';
import '../settings/settings_page.dart';
import '../stats/stats_page.dart';
import '../timeline/timeline_page.dart';
import 'bloc/bloc.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final _tabs = const [
    CategoriesPage(),
    Center(child: Text('2')),
    TimelinePage(),
    StatsPage(),
  ];

  void _selectTab(int tab) {
    context.read<HomeBloc>().add(TabSelectedEvent(index: tab));
  }

  Widget _bottomNavigationBar() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return BottomNavigationBar(
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Colors.indigo,
          backgroundColor: Theme.of(context).primaryColor,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              label: 'Daily',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.timeline_outlined),
              label: 'Timeline',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
          ],
          onTap: _selectTab,
          currentIndex: state.index,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cool Notes', style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(SettingsPage.routeName),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return _tabs[state.index];
        },
      ),
    );
  }
}
