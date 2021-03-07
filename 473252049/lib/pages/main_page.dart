import 'package:chat_journal/blocs/theme_mode_bloc/thememode_bloc.dart';
import 'package:chat_journal/chats/cubit/chats_cubit.dart';
import 'package:chat_journal/mocks/mocks.dart';
import 'package:chat_journal/pages/category_add_edit_page.dart';
import 'package:chat_journal/pages/category_page/category_page.dart';
import 'package:chat_journal/tabs/home_tab/hometab_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/main_page_bottom_navigation_bar.dart';
import '../components/main_page_drawer.dart';
import '../main.dart';
import '../tabs/home_tab/home_tab.dart';

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
        title: Text(currentPageIndex == 0 ? 'Home' : 'Other page'),
        actions: [
          IconButton(
            icon: Icon(
                BlocProvider.of<ThememodeBloc>(context).state.themeMode ==
                        ThemeMode.light
                    ? Icons.bedtime_outlined
                    : Icons.bedtime),
            onPressed: () {
              BlocProvider.of<ThememodeBloc>(context).add(ThememodeChanged());
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
                        value: BlocProvider.of<ChatsCubit>(context),
                        child: CategoryAddEditPage(
                          mode: CategoryAddEditMode.add,
                        ),
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
