import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../../../logic/cubit/home_cubit.dart';

Widget bottomNavigationBar() {
  return BlocBuilder<HomeCubit, HomeState>(
    builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).disabledColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black.withOpacity(0.2),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: GNav(
              color: Theme.of(context).primaryColor,
              activeColor: Theme.of(context).primaryColor,
              tabBackgroundColor: Theme.of(context).cardColor,
              gap: 10,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              duration: const Duration(milliseconds: 600),
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.tasks,
                  text: 'Daily',
                ),
                GButton(
                  icon: LineIcons.map,
                  text: 'Timeline',
                ),
                GButton(
                  icon: Icons.explore_outlined,
                  text: 'Explore',
                ),
              ],
              onTabChange: (index) =>
                  context.read<HomeCubit>().tabSelect(index),
              selectedIndex: state.index,
            ),
          ),
        ),
      );
    },
  );
}
