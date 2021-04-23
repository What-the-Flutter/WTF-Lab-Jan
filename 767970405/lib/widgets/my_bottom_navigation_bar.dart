import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../filter_screen/filter_screen_cubit.dart';
import '../home_screen/home_screen_cubit.dart';
import '../messages_screen/screen_message_cubit.dart';
import '../timeline_screen/timeline_screen_cubit.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const MyBottomNavigationBar({
    Key key,
    this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) => BottomNavigationBar(
        currentIndex: state.currentIndex,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Daily',
            icon: Icon(
              Icons.event_note_sharp,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Timeline',
            icon: Icon(
              Icons.timeline,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Explore',
            icon: Icon(
              Icons.explore,
            ),
          )
        ],
        onTap: (index) {
          if (state.currentIndex == index) {
            return;
          }
          context.read<HomeScreenCubit>().changeScreen(index);
          if (index == 2) {
            context.read<FilterScreenCubit>().loadListsItem(
                  context.read<HomeScreenCubit>().state.pages,
                  context.read<ScreenMessageCubit>().state.tags,
                );
            final state = context.read<FilterScreenCubit>().state;
            context.read<TimelineScreenCubit>().configureList(
                  selectedPages: state.pages
                      .where((element) => element.isSelected)
                      .toList(),
                  selectedTags: state.tags
                      .where((element) => element.isSelected)
                      .toList(),
                  selectedLabel: state.labels
                      .where((element) => element.isSelected)
                      .toList(),
                );
          }
          context.read<TimelineScreenCubit>().changeMode();
        },
      ),
    );
  }
}
