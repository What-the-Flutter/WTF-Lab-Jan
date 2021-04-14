import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';

import '../event.dart';
import '../utils/icons.dart';
import 'cubit_timeline_page.dart';
import 'states_timeline_page.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Event> _eventsList;

  @override
  void initState() {
    BlocProvider.of<CubitTimelinePage>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitTimelinePage, StatesTimelinePage>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(state),
          body: _directionality(state),
        );
      },
    );
  }

  AppBar _appBar(StatesTimelinePage state) {
    return AppBar(
      title: state.isSearch
          ? _textFieldSearch
          : Text(
              'Timeline',
            ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            right: 10.0,
          ),
          child: Row(
            children: [
              if (!state.isSearch)
                IconButton(
                  icon: Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                  ),
                  onPressed: () => BlocProvider.of<CubitTimelinePage>(context)
                      .setSortedByBookmarksState(!state.isSortedByBookmarks),
                ),
              IconButton(
                icon: Icon(
                  state.isSearch ? Icons.clear : Icons.search,
                ),
                onPressed: () {
                  _focusNode.requestFocus();
                  BlocProvider.of<CubitTimelinePage>(context)
                      .setTextSearchState(!state.isSearch);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextField get _textFieldSearch {
    return TextField(
      controller: _textEditingController,
      focusNode: _focusNode,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: 'Enter event...',
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        border: InputBorder.none,
        filled: false,
      ),
    );
  }

  Directionality _directionality(StatesTimelinePage state) {
    return Directionality(
      textDirection:
          state.isBubbleAlignment ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: _listView(state),
    );
  }

  void _updateList(StatesTimelinePage state) {
    BlocProvider.of<CubitTimelinePage>(context).sortEventsByDate();
    if (state.isSortedByBookmarks) {
      _eventsList = state.eventsList
          .where((element) => element.bookmarkIndex == 1)
          .toList();
    } else if (state.isSearch) {
      _eventsList = state.eventsList
          .where(
            (element) => element.text.contains(_textEditingController.text),
          )
          .toList();
    } else {
      _eventsList = state.eventsList;
    }
  }

  ListView _listView(StatesTimelinePage state) {
    _updateList(state);
    return ListView.builder(
      reverse: true,
      scrollDirection: Axis.vertical,
      itemCount: _eventsList.length,
      itemBuilder: (context, index) {
        final event = _eventsList[index];
        return _showEventList(state, event);
      },
    );
  }

  Widget _showEventList(StatesTimelinePage state, Event event) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
            ),
            child: Align(
              alignment: state.isCenterDateBubble
                  ? Alignment.center
                  : Alignment.centerLeft,
              child: Container(
                width: 140,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      40.0,
                    ),
                  ),
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                ),
                child: Center(
                  child: ListTile(
                    title: Text(
                      event.date,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              20.0,
            ),
            child: Card(
              elevation: 3,
              child: ListTile(
                leading: event.circleAvatarIndex != -1
                    ? _circleAvatar(
                        icons[event.circleAvatarIndex],
                      )
                    : null,
                tileColor: Theme.of(context).appBarTheme.color,
                title: event.imagePath != null
                    ? Image.file(
                        File(event.imagePath),
                      )
                    : HashTagText(
                        text: event.text,
                        basicStyle: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.bodyText1.fontSize,
                        ),
                        decoratedStyle: TextStyle(
                          color: Colors.yellow,
                          fontSize:
                              Theme.of(context).textTheme.bodyText1.fontSize,
                        ),
                        onTap: (text) {
                          BlocProvider.of<CubitTimelinePage>(context)
                              .setTextSearchState(!state.isSearch);
                          _textEditingController.text = text;
                        },
                      ),
                subtitle: Text(
                  event.time,
                  style: TextStyle(
                    color: Theme.of(context)
                        .floatingActionButtonTheme
                        .foregroundColor,
                  ),
                ),
                trailing: event.bookmarkIndex == 1
                    ? Icon(
                        Icons.bookmark_border,
                        size: 30,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  CircleAvatar _circleAvatar(IconData icon) {
    return CircleAvatar(
      child: Icon(
        icon,
        size: 30,
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
