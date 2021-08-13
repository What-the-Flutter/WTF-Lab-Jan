import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/bloc.dart';
import '../categories/categories_page.dart';
import 'bloc/bloc.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final _tabs = const [
    CategoriesPage(),
    Center(child: Text('2')),
    Center(child: Text('3')),
    Center(child: Text('4')),
  ];

  void _changeTheme(BuildContext context) {
    context.read<AppBloc>().add(const SwitchThemeEvent());
  }

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
              icon: Icon(Icons.explore_outlined),
              label: 'Explore',
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
    final isDarkMode = context.read<AppBloc>().state.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () => _changeTheme(context),
            icon: isDarkMode ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
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
