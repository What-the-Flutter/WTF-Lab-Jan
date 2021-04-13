import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../event_page/event.dart';
import '../../widget/event_list_widget.dart';
import 'filter_page/filter_page.dart';
import 'filter_page/filter_page_cubit.dart';
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
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.filter_list),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FilterPage(),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Event> _calculateFilterList(TimelinePageStates state) {
    var filterList = <Event>[];
    for (var i = 0;
        i <
            BlocProvider.of<FilterPageCubit>(context)
                .state
                .filterNotesList
                .length;
        i++) {
      for (var j = 0; j < state.eventList.length; j++) {
        if (state.eventList[j].noteId ==
            BlocProvider.of<FilterPageCubit>(context)
                .state
                .filterNotesList[i]
                .id) {
          filterList.add(state.eventList[j]);
        }
      }
    }
    return filterList;
  }

  List<Event> _calculateLabelFilterList(
      TimelinePageStates state, List<Event> eventList) {
    var filterList = <Event>[];
    for (var i = 0;
        i <
            BlocProvider.of<FilterPageCubit>(context)
                .state
                .filterLabelList
                .length;
        i++) {
      for (var j = 0; j < eventList.length; j++) {
        if (eventList[j].indexOfCircleAvatar ==
            BlocProvider.of<FilterPageCubit>(context)
                .state
                .filterLabelList[i]) {
          filterList.add(eventList[j]);
        }
      }
    }
    return filterList;
  }

  Widget _timelineBody(TimelinePageStates state) {
    final _filterEventList = BlocProvider.of<FilterPageCubit>(context)
            .state
            .filterNotesList
            .isNotEmpty
        ? _calculateFilterList(state)
        : state.eventList;

    final _filterLabelList = BlocProvider.of<FilterPageCubit>(context)
            .state
            .filterLabelList
            .isNotEmpty
        ? _calculateLabelFilterList(state, _filterEventList)
        : _filterEventList;

    final _searchedEventList =
        state.isIconButtonSearchPressed && state.isWriting
            ? _filterLabelList
                .where((element) => element.text.contains(state.searchText))
                .toList()
            : _filterLabelList;

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
