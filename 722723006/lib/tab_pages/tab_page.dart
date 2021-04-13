import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../settings/settings_page.dart';
import '../statistics/statistics_page.dart';
import '../theme/theme_cubit.dart';
import 'home_page/home_page.dart';
import 'tab_page_cubit.dart';
import 'timeline_page/timeline_page.dart';
import 'timeline_page/timeline_page_cubit.dart';
import 'timeline_page/timeline_page_states.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with TickerProviderStateMixin {
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchTextFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TimelinePageCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelinePageCubit, TimelinePageStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(state),
          drawer: _drawer,
          bottomNavigationBar: _bottomNavigationBar,
          body: _tabPageBody(context),
        );
      },
    );
  }

  Widget _appBar(TimelinePageStates state) {
    return AppBar(
      centerTitle: true,
      title: state.isIconButtonSearchPressed &&
              BlocProvider.of<TabPageCubit>(context).state != 0
          ? TextField(
              focusNode: _searchTextFieldFocusNode,
              controller: _searchTextController,
              onChanged: (value) {
                value.isEmpty
                    ? BlocProvider.of<TimelinePageCubit>(context)
                        .setWritingState(false)
                    : BlocProvider.of<TimelinePageCubit>(context)
                        .setWritingState(true);
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
              BlocProvider.of<TabPageCubit>(context).state == 0
                  ? 'Home'
                  : 'Timeline',
            ),
      actions: [
        if (BlocProvider.of<TabPageCubit>(context).state != 0)
          state.isWriting
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchTextController.clear();
                    BlocProvider.of<TimelinePageCubit>(context)
                        .setWritingState(false);
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    BlocProvider.of<TimelinePageCubit>(context)
                        .setIconButtonSearchState();
                    _searchTextFieldFocusNode.requestFocus();
                  },
                ),
        BlocProvider.of<TabPageCubit>(context).state == 0
            ? IconButton(
                icon: Icon(Icons.invert_colors),
                onPressed: () =>
                    BlocProvider.of<ThemeCubit>(context).changeTheme(),
              )
            : IconButton(
                icon: Icon(Icons.bookmark_border),
                onPressed: () => BlocProvider.of<TimelinePageCubit>(context)
                    .setAllBookmarkedState(),
              ),
      ],
    );
  }

  BottomNavigationBar get _bottomNavigationBar {
    return BottomNavigationBar(
      currentIndex: BlocProvider.of<TabPageCubit>(context).state,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_view_day_sharp),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      onTap: (index) =>
          BlocProvider.of<TabPageCubit>(context).setSelectedIndex(index),
    );
  }

  Drawer get _drawer {
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
                  subtitle: Text(
                    '(Click here to setup Drive backups)',
                    style: TextStyle(color: Colors.white),
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

  Widget _tabPageBody(context) {
    return BlocProvider.of<TabPageCubit>(context).state == 0
        ? HomePageBody()
        : TimelinePage();
  }
}
