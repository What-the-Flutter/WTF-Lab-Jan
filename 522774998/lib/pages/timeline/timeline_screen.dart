import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_cubit.dart';
import '../home/home_screen_cubit.dart';
import '../search/searching_message.dart';
import '../search/searching_messages_cubit.dart';
import '../settings/settings_page.dart';
import '../settings/settings_page_cubit.dart';
import 'timeline_screen_cubit.dart';
import 'timeline_screen_state.dart';

class TimelineScreen extends StatefulWidget {
  static const routeName = '/Timeline';

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  Widget build(BuildContext context) {
    context
        .read<TimelineScreenCubit>()
        .downloadDataFromAllPages(TimelineMainAppBar());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: BlocBuilder<TimelineScreenCubit, TimelineScreenState>(
          builder: (context, state) => state.appBar,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  DateFormat.yMMMMd('en_US').format(DateTime.now()),
                  style: TextStyle(fontSize: 30),
                ),
              ),
              decoration: BoxDecoration(
                color: BlocProvider.of<ThemeCubit>(context)
                    .state
                    .theme
                    .accentColor,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                size: 30,
              ),
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  SettingsPage.routeName,
                );
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<TimelineScreenCubit, TimelineScreenState>(
        builder: (context, state) {
          final indexBackground =
              BlocProvider.of<SettingPageCubit>(context).state.indexBackground;
          if (state is! TimelineScreenAwait) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(galleryItems[indexBackground]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child:
                        BlocBuilder<TimelineScreenCubit, TimelineScreenState>(
                      builder: (context, state) {
                        return Stack(
                          children: [
                            ListView.builder(
                              reverse: true,
                              itemCount: state.list.length,
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    if (state.list[state.list.length - i - 1]
                                        .isVisible)
                                      if (state.list[state.list.length - i - 1]
                                              .id ==
                                          context
                                              .read<TimelineScreenCubit>()
                                              .checkDate(state
                                                  .list[
                                                      state.list.length - i - 1]
                                                  .time))
                                        DateMessageTimeline(
                                            index: state.list.length - i - 1),
                                    if (state.list[state.list.length - i - 1]
                                        .isVisible)
                                      Dismissible(
                                        confirmDismiss: (direction) async {
                                          context
                                              .read<TimelineScreenCubit>()
                                              .selection(
                                                  state.list.length - i - 1);
                                          final res = await showDialog(
                                            context: context,
                                            builder: (alertContext) {
                                              return AlertDialog(
                                                content: Text(
                                                    'Are you sure you want to delete?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              TimelineScreenCubit>()
                                                          .toMainAppBar();
                                                      context
                                                          .read<
                                                              TimelineScreenCubit>()
                                                          .selection(state
                                                                  .list.length -
                                                              i -
                                                              1);
                                                      Navigator.of(alertContext)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              TimelineScreenCubit>()
                                                          .delete();
                                                      Navigator.of(alertContext)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          return res;
                                        },
                                        background: slideLeftBackground(),
                                        key: UniqueKey(),
                                        child: MessageTimeline(
                                          index: state.list.length - i - 1,
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('Await'),
            );
          }
        },
      ),
    );
  }

  Widget slideLeftBackground() {
    return Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    );
  }
}

class TimelineMainAppBar extends StatefulWidget {
  const TimelineMainAppBar({Key key}) : super(key: key);

  @override
  _TimelineMainAppBarState createState() => _TimelineMainAppBarState();
}

class _TimelineMainAppBarState extends State<TimelineMainAppBar> {
  bool _isPressed = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimelineScreenCubit, TimelineScreenState>(
      listener: (context, state) =>
          context.read<TimelineScreenCubit>().toSelectionAppBar(),
      listenWhen: (prevState, curState) =>
          prevState.counter == 0 && curState.counter == 1 ? true : false,
      child: AppBar(
        title: Center(
          child: Text(
            'Timeline',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                context.read<SearchMessageCubit>().isAll = true;
                Navigator.pushNamed(
                  context,
                  SearchingPage.routeName,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: IconButton(
              icon: _isPressed
                  ? Icon(Icons.bookmark_border)
                  : Icon(
                      Icons.bookmark,
                      color: Colors.yellow,
                    ),
              onPressed: () {
                setState(() {
                  _isPressed = !_isPressed;
                });
                _isPressed
                    ? context.read<TimelineScreenCubit>().showAll()
                    : context.read<TimelineScreenCubit>().showBookmarks();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineSelectionAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<TimelineScreenCubit, TimelineScreenState>(
      listener: (context, state) =>
          context.read<TimelineScreenCubit>().toMainAppBar(),
      listenWhen: (prevState, curState) =>
          prevState.counter >= 1 && curState.counter == 0 ? true : false,
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: context.read<TimelineScreenCubit>().backToMainAppBar,
        ),
        title: BlocBuilder<TimelineScreenCubit, TimelineScreenState>(
          builder: (context, state) => Text(
            state.counter.toString(),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.share),
              onPressed: () => createDialog(context),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.copy),
              onPressed: context.read<TimelineScreenCubit>().copy,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.bookmark_border),
              onPressed:
                  context.read<TimelineScreenCubit>().makeBookmarkSelected,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: context.read<TimelineScreenCubit>().delete,
            ),
          ),
        ],
      ),
    );
  }

  void createDialog(BuildContext context) async {
    var index = 0;
    int id;
    var list = await context.read<HomeScreenCubit>().state.list;
    for (var i = 0;
        i < context.read<TimelineScreenCubit>().state.list.length;
        i++) {
      if (context.read<TimelineScreenCubit>().state.list[i].isSelected) {
        id = context.read<TimelineScreenCubit>().state.list[i].idMessagePage;
        break;
      }
    }
    list = list.where((element) => element.id != id).toList();
    showDialog(
      context: context,
      builder: (alertContext) => AlertDialog(
        content: StatefulBuilder(
          builder: (context, setState) => Container(
            height: 200,
            width: 100,
            child: ListView(
              children: <Widget>[
                for (var i = 0; i < list.length; i++)
                  RadioListTile<int>(
                    title: Text(list[i].title),
                    value: i,
                    groupValue: index,
                    onChanged: (value) => setState(() => index = value),
                  ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(alertContext),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: BlocProvider.of<ThemeCubit>(context)
                              .state
                              .theme
                              .primaryColor),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: OutlinedButton(
                  onPressed: () {
                    context
                        .read<TimelineScreenCubit>()
                        .listSelected(list[index].id);
                    Navigator.pop(alertContext);
                  },
                  child: Center(
                    child: Text(
                      'Choose',
                      style: TextStyle(
                          color: BlocProvider.of<ThemeCubit>(context)
                              .state
                              .theme
                              .primaryColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MessageTimeline extends StatelessWidget {
  final int index;

  const MessageTimeline({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<TimelineScreenCubit>().state;
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Align(
        alignment: BlocProvider.of<SettingPageCubit>(context)
                .state
                .isBubbleAlignmentSwitched
            ? Alignment.bottomRight
            : Alignment.bottomLeft,
        child: GestureDetector(
          onTap: state is TimelineScreenSelection
              ? () => context.read<TimelineScreenCubit>().selection(index)
              : () => context.read<TimelineScreenCubit>().makeBookmark(index),
          onLongPress: () =>
              context.read<TimelineScreenCubit>().selection(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: BlocProvider.of<SettingPageCubit>(context)
                        .state
                        .isBubbleAlignmentSwitched
                    ? Radius.zero
                    : Radius.circular(10),
                bottomLeft: BlocProvider.of<SettingPageCubit>(context)
                        .state
                        .isBubbleAlignmentSwitched
                    ? Radius.circular(10)
                    : Radius.zero,
              ),
              border: Border.all(
                color: state.list[index].isSelected
                    ? BlocProvider.of<ThemeCubit>(context)
                        .state
                        .theme
                        .primaryColor
                    : Colors.orange,
              ),
              color: state.list[index].isSelected
                  ? BlocProvider.of<ThemeCubit>(context)
                      .state
                      .theme
                      .backgroundColor
                  : Colors.orange[50],
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.read<TimelineScreenCubit>().getTitle(
                      state.list[index].idMessagePage,
                      context.read<HomeScreenCubit>().state.list),
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                if (state.list[index].icon != null)
                  Icon(state.list[index].icon),
                File(state.list[index].data).existsSync() == true
                    ? Container(
                        width: 150,
                        height: 250,
                        child: Image.file(
                          File(state.list[index].data),
                        ),
                      )
                    : HashTagText(
                        text: state.list[index].data,
                        basicStyle: TextStyle(
                          fontSize: BlocProvider.of<SettingPageCubit>(context)
                              .state
                              .fontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                        decoratedStyle: TextStyle(
                          fontSize: BlocProvider.of<SettingPageCubit>(context)
                              .state
                              .fontSize,
                          color: Colors.deepPurple,
                        ),
                        onTap: (text) {
                          BlocProvider.of<SearchMessageCubit>(context)
                              .controller
                              .text = text;
                          Navigator.pushNamed(
                            context,
                            SearchingPage.routeName,
                            arguments: true,
                          );
                        },
                      ),
                Wrap(
                  direction: Axis.horizontal,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(state.list[index].time),
                      style: TextStyle(
                        fontSize: BlocProvider.of<SettingPageCubit>(context)
                            .state
                            .fontSize,
                        color: Colors.grey,
                      ),
                    ),
                    if (state.list[index].isBookmark)
                      Icon(
                        Icons.bookmark,
                        color: Colors.yellow,
                        size: 20,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateMessageTimeline extends StatelessWidget {
  final int index;

  const DateMessageTimeline({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<TimelineScreenCubit>().state;
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Align(
        alignment: BlocProvider.of<SettingPageCubit>(context)
                .state
                .isDateAlignmentSwitched
            ? Alignment.bottomCenter
            : BlocProvider.of<SettingPageCubit>(context)
                    .state
                    .isBubbleAlignmentSwitched
                ? Alignment.bottomRight
                : Alignment.bottomLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            border: Border.all(
              color:
                  BlocProvider.of<ThemeCubit>(context).state.theme.primaryColor,
            ),
            color: BlocProvider.of<ThemeCubit>(context)
                .state
                .theme
                .backgroundColor,
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Text(
            context
                .read<TimelineScreenCubit>()
                .calculateDate(state.list[index].time),
            style: TextStyle(
              fontSize:
                  BlocProvider.of<SettingPageCubit>(context).state.fontSize,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
