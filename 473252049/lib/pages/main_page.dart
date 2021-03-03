import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home_page_bloc/homepage_bloc.dart';
import '../components/main_page_bottom_navigation_bar.dart';
import '../components/main_page_drawer.dart';
import '../main.dart';
import '../tabs/home_tab.dart';
import 'category_add_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _children = [
    HomeTab(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
  ];

  int currentPageIndex = 0;

  void _onTabTap(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Exp'),
        actions: [
          IconButton(
            icon: Icon(ThemeSwitcher.of(context).themeMode == ThemeMode.light
                ? Icons.bedtime_outlined
                : Icons.bedtime),
            onPressed: () {
              ThemeSwitcher.of(context).switchThemeMode();
            },
          ),
        ],
      ),
      body: _children[currentPageIndex],
      drawer: MainPageDrawer(),
      bottomNavigationBar:
          MainPageBottomNavigationBar(currentPageIndex, _onTabTap),
      floatingActionButton: currentPageIndex == 0
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return BlocProvider.value(
                        value: BlocProvider.of<HomepageBloc>(context),
                        child: CategoryAddPage(),
                      );
                    },
                  ),
                );
              },
            )
          : null,
    );
  }
}
