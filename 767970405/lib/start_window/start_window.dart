import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_screen/home_screen.dart';
import '../home_screen/home_screen_cubit.dart';
import '../timeline_screen/timeline_screen.dart';
import '../widgets/my_bottom_navigation_bar.dart';

class StartWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) => IndexedStack(
        index: state.currentIndex,
        children: <Widget>[
          HomeWindow(),
          Scaffold(
            appBar: AppBar(
              title: Text('Statistic'),
            ),
            body: Center(
              child: Text('In future'),
            ),
            bottomNavigationBar: MyBottomNavigationBar(
              currentIndex: state.currentIndex,
            ),
          ),
          TimelineScreen(),
          Scaffold(
            appBar: AppBar(
              title: Text('Explore'),
            ),
            body: Center(
              child: Text('In future'),
            ),
            bottomNavigationBar: MyBottomNavigationBar(
              currentIndex: state.currentIndex,
            ),
          ),
        ],
      ),
    );
  }
}
