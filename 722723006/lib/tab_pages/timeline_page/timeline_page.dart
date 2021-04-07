import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_page/widget/event_list_widget.dart';

import 'timeline_page_cubit.dart';
import 'timeline_page_states.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  void initState() {
    BlocProvider.of<TimelinePageCubit>(context).initEventList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelinePageCubit, TimelinePageStates>(
      builder: (context, state) {
        return Scaffold(
          body: _timelineBody(state),
        );
      },
    );
  }

  Widget _timelineBody(TimelinePageStates state) {
    final _searchedEventList =
        state.isIconButtonSearchPressed && state.isWriting
            ? state.eventList
                .where((element) => element.text.contains(state.searchText))
                .toList()
            : state.eventList;

    final _allBookmarkedList = state.isAllBookmarked
        ? _searchedEventList.where((element) => element.isBookmarked).toList()
        : _searchedEventList;
    return LiveList.options(
      options: LiveOptions(
        visibleFraction: 0.025,
      ),
      reverse: true,
      itemCount: state.isAllBookmarked
          ? _allBookmarkedList.length
          : _searchedEventList.length,
      itemBuilder: (context, index, animation) {
        final _event = state.isAllBookmarked
            ? _allBookmarkedList[index]
            : _searchedEventList[index];
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: EventListWidget(
              _event,
              state,
              onDismissed: (direction) =>
                  BlocProvider.of<TimelinePageCubit>(context)
                      .deleteEvent(_event),
            ),
          ),
        );
      },
    );
  }
}
