import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_journal/filter_screen/filter_screen_cubit.dart';
import 'package:my_chat_journal/home_screen/home_screen_cubit.dart';
import 'package:my_chat_journal/timeline_screen/timeline_screen.dart';
import 'package:my_chat_journal/timeline_screen/timeline_screen_cubit.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const MyBottomNavigationBar({Key key, this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
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
      onTap: (index) async {
        if (context.read<HomeScreenCubit>().state.currentIndex == index) {
          return;
        }
        if (index == 0) {
          Navigator.pushNamed(
            context,
            '/',
          );
        }
        if (index == 2) {
          await context.read<FilterScreenCubit>().loadListsItem();
          final state = context.read<FilterScreenCubit>().state;
          await context.read<TimelineScreenCubit>().configureList(
                selectedPages:
                    state.pages.where((element) => element.isSelected).toList(),
                selectedTags:
                    state.tags.where((element) => element.isSelected).toList(),
                selectedLabel: state.labels
                    .where((element) => element.isSelected)
                    .toList(),
              );
          Navigator.pushNamed(
            context,
            TimelineScreen.routeName,
          );
        }

        context.read<HomeScreenCubit>().changeScreen(index);
      },
    );
  }
}
