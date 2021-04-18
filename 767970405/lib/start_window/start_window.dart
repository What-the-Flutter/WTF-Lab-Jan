import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_journal/auth_screen/auth_cubit.dart';
import 'package:my_chat_journal/auth_screen/auth_screen.dart';
import 'package:my_chat_journal/settings_screen/chat_interface_setting_cubit.dart';
import 'package:my_chat_journal/widgets/drawer.dart';

import '../home_screen/home_screen.dart';
import '../home_screen/home_screen_cubit.dart';
import '../timeline_screen/timeline_screen.dart';
import '../widgets/my_bottom_navigation_bar.dart';

class StartWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
      final bottomNavigationBar = MyBottomNavigationBar(
        currentIndex: state.currentIndex,
      );
      final drawer = MyDrawer();
      return IndexedStack(
        index: state.currentIndex,
        children: <Widget>[
          HomeWindow(
            drawer: drawer,
            bottomNavigationBar: bottomNavigationBar,
          ),
          Scaffold(
            appBar: AppBar(
              title: Text('Daily'),
            ),
            body: Center(
              child: Text('In future'),
            ),
            drawer: drawer,
            bottomNavigationBar: bottomNavigationBar,
          ),
          TimelineScreen(
            drawer: drawer,
            bottomNavigationBar: bottomNavigationBar,
          ),
          Scaffold(
            appBar: AppBar(
              title: Text('Explore'),
            ),
            body: Center(
              child: Text('In future'),
            ),
            drawer: drawer,
            bottomNavigationBar: bottomNavigationBar,
          ),
        ],
      );
    });
  }
}
