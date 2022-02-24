import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

import '../../data/shared_preferences_provider.dart';
import '../../event.dart';
import '../../icons.dart';
import '../../theme/cubit_theme.dart';
import '../home_page/home_page.dart';
import '../settings_page/settings_page.dart';
import '../statistic_page/statistics_page.dart';
import 'cubit_timeline_page.dart';
import 'states_timeline_page.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final TextEditingController textSearchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Event> _myEventList = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CubitTimelinePage>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitTimelinePage, StatesTimelinePage>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(state),
          body: _timelinePageBody(state),
          drawer: _drawer,
          floatingActionButton: _floatingActionButton(),
          bottomNavigationBar: _bottomNavigationBar,
        );
      },
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      child: BlocProvider.of<CubitTheme>(context).state.isLightTheme!
          ? Lottie.network(
              'https://assets4.lottiefiles.com/packages/lf20_kcywyypy.json',
              repeat: true,
              reverse: true,
              animate: true,
            )
          : Lottie.network(
              'https://assets7.lottiefiles.com/packages/lf20_u0sqq9uw.json',
              repeat: true,
              reverse: true,
              animate: true,
            ),
      onPressed: () {},
    );
  }

  Column _timelinePageBody(StatesTimelinePage state) {
    return Column(
      children: [
        Expanded(
          child: _listView(state),
        ),
      ],
    );
  }

  Drawer get _drawer {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text('Information'),
          ),
          GestureDetector(
            child: ListTile(
              leading: Container(
                height: 35,
                width: 35,
                child: BlocProvider.of<CubitTheme>(context).state.isLightTheme!
                    ? Lottie.network(
                        'https://assets4.lottiefiles.com/packages/lf20_hvxmoeqb.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                      )
                    : Lottie.network(
                        'https://assets5.lottiefiles.com/packages/lf20_i85votuf.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                      ),
              ),
              title: const Text('Profile'),
            ),
          ),
          GestureDetector(
            child: ListTile(
              leading: Container(
                height: 35,
                width: 35,
                child: BlocProvider.of<CubitTheme>(context).state.isLightTheme!
                    ? Lottie.network(
                        'https://assets10.lottiefiles.com/packages/lf20_6ctkb0oz.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                      )
                    : Lottie.network(
                        'https://assets4.lottiefiles.com/packages/lf20_nrjiwkxn.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                      ),
              ),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            child: ListTile(
              leading: Container(
                height: 35,
                width: 35,
                child: const Icon(Icons.multiline_chart),
              ),
              title: const Text('Statistics'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StatisticsPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ListView _listView(StatesTimelinePage state) {
    _myEventList = state.isSearch
        ? state.eventList
            .where(
                (element) => element.text.contains(textSearchController.text))
            .toList()
        : state.isSortedByBookmarks
            ? state.eventList
                .where((element) => element.bookmarkIndex == 1)
                .toList()
            : state.eventList;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: _myEventList.length,
      itemBuilder: (context, index) {
        return _showEventList(_myEventList[index], index, state);
      },
    );
  }

  Widget _showEventList(Event event, int index, StatesTimelinePage state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      child: Column(
        children: [
          ListTile(
            title: SharedPreferencesProvider().fetchCenterDateBubble()
                ? Center(
                    child: Text(state.eventList[index].date),
                  )
                : Align(
                    alignment: state.isBubbleAlignment
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Text(
                      state.eventList[index].date,
                    ),
                  ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Align(
              alignment: state.isBubbleAlignment
                  ? Alignment.topRight
                  : Alignment.topLeft,
              child: Container(
                width: 230,
                child: Card(
                  color: Colors.blueGrey,
                  elevation: 5,
                  child: ListTile(
                    leading: event.indexOfCircleAvatar != -1
                        ? CircleAvatar(
                            child: iconsList[event.indexOfCircleAvatar],
                          )
                        : null,
                    title: event.imagePath != ''
                        ? Image.network(event.imagePath)
                        : HashTagText(
                            decoratedStyle: const TextStyle(
                              color: Colors.red,
                            ),
                            text: event.text,
                            basicStyle: TextStyle(
                              color: BlocProvider.of<CubitTheme>(context)
                                      .state
                                      .isLightTheme!
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                    subtitle: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(event.time),
                    ),
                    trailing: event.bookmarkIndex == 1
                        ? const Icon(
                            Icons.bookmark,
                            size: 30,
                          )
                        : null,
                    onTap: () => BlocProvider.of<CubitTimelinePage>(context)
                        .updateBookmark(index),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(StatesTimelinePage state) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: state.isSearch ? _textFieldSearch(state) : const Text('Timeline'),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: state.isSearch
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    textSearchController.clear();
                    BlocProvider.of<CubitTimelinePage>(context)
                        .setIsSearch(!state.isSearch);
                  },
                )
              : Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _searchFocusNode.requestFocus();
                        BlocProvider.of<CubitTimelinePage>(context)
                            .setIsSearch(!state.isSearch);
                      },
                    ),
                    IconButton(
                      icon: state.isSortedByBookmarks
                          ? const Icon(Icons.bookmark)
                          : const Icon(Icons.bookmark_border),
                      onPressed: () =>
                          BlocProvider.of<CubitTimelinePage>(context)
                              .setSortedByBookmarksState(
                                  !state.isSortedByBookmarks),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  BottomNavigationBar get _bottomNavigationBar {
    return BottomNavigationBar(
      onTap: (value) {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRight,
            child: HomePage(),
          ),
        );
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_view_day_sharp,
          ),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          backgroundColor: BlocProvider.of<CubitTheme>(context)
              .state
              .themeData
              ?.backgroundColor,
          icon: const Icon(
            Icons.timeline,
          ),
          label: 'TimeLine',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.explore,
          ),
          label: 'Explore',
        ),
      ],
      currentIndex: 2,
      showUnselectedLabels: true,
    );
  }

  HashTagTextField _textFieldSearch(StatesTimelinePage state) {
    return HashTagTextField(
      decoratedStyle: const TextStyle(
        color: Colors.red,
      ),
      onChanged: (value) => BlocProvider.of<CubitTimelinePage>(context)
          .setEventList(state.eventList),
      controller: textSearchController,
      focusNode: _searchFocusNode,
      decoration: const InputDecoration(
        hintText: 'Enter text',
        border: InputBorder.none,
        filled: true,
      ),
    );
  }
}
