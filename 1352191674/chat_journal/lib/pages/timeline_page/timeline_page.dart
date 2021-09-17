import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../models/event_model.dart';
import '../events_page/event_page.dart';
import '../filter_page/filter_page.dart';
import '../filter_page/fllter_page_cubit.dart';
import '../settings_page/settings_page.dart';
import '../statistics/statistics_page.dart';
import 'timeline_page_cubit.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchTextFieldFocusNode = FocusNode();

  @override
  void initState() {
    BlocProvider.of<TimelinePageCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelinePageCubit, TimelinePageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(state),
          drawer: _drawer(context),
          body: _timelineBody(state),
          floatingActionButton: _floatingActionButton(),
        );
      },
    );
  }

  AppBar _appBar(TimelinePageState state) {
    return AppBar(
      centerTitle: true,
      title: state.isSearchButtonPressed
          ? TextField(
              focusNode: _searchTextFieldFocusNode,
              controller: _searchTextController,
              onChanged: (value) {
                value.isEmpty
                    ? BlocProvider.of<TimelinePageCubit>(context)
                        .setWriting(false)
                    : BlocProvider.of<TimelinePageCubit>(context)
                        .setWriting(true);
                BlocProvider.of<TimelinePageCubit>(context)
                    .setSearchText(value);
              },
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white70),
              ),
            )
          : Text(
              'Timeline',
              style: TextStyle(color: Colors.white),
            ),
      actions: [
        state.isWriting
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchTextController.clear();
                  BlocProvider.of<TimelinePageCubit>(context)
                      .setWriting(false);
                },
              )
            : IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  BlocProvider.of<TimelinePageCubit>(context)
                      .setIconButtonSearch();
                  _searchTextFieldFocusNode.requestFocus();
                },
              ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () => BlocProvider.of<TimelinePageCubit>(context)
              .setAllBookmarked(),
        ),
      ],
    );
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 145,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ListTile(
                  title: Text(
                    DateFormat.yMMMd('en_US').format(
                      DateTime.now(),
                    ),
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Search'),
            leading: Icon(Icons.search),
          ),
          ListTile(
            title: Text('Notifications'),
            leading: Icon(Icons.notifications),
          ),
          ListTile(
            title: Text('Statistics'),
            leading: Icon(Icons.timeline),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StatisticsPage(),
              ),
            ),
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ),
            ),
          ),
          ListTile(
            title: Text('Feedback'),
            leading: Icon(Icons.mail),
          ),
        ],
      ),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.of(context).push(_createRoute());
        BlocProvider.of<TimelinePageCubit>(context).updateList();
      },
      child: Icon(Icons.filter_list_outlined),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const FilterPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  List<Event> _calculateFilterList(TimelinePageState state) {
    var filterList = <Event>[];
    for (var i = 0;
        i <
            BlocProvider.of<FilterPageCubit>(context)
                .state
                .filterNotesList
                .length;
        i++) {
      for (var j = 0; j < state.allEventList.length; j++) {
        if (state.allEventList[j].noteId ==
            BlocProvider.of<FilterPageCubit>(context)
                .state
                .filterNotesList[i]
                .id) {
          filterList.add(state.allEventList[j]);
        }
      }
    }
    return filterList;
  }

  List<Event> _calculateLabelFilterList(
      TimelinePageState state, List<Event> eventList) {
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

  Widget _timelineBody(TimelinePageState state) {
    final _filterEventList = BlocProvider.of<FilterPageCubit>(context)
            .state
            .filterNotesList
            .isNotEmpty
        ? _calculateFilterList(state)
        : state.allEventList;

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
      itemCount: state.isAllBookmarked
          ? _allBookmarkedList.length
          : _searchedEventList.length,
      options: LiveOptions(
        visibleFraction: 0.025,
      ),
      reverse: true,
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
            child: EventListWidget(_event, state),
          ),
        );
      },
    );
  }
}
