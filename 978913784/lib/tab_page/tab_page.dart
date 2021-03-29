import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:animator/animator.dart';
import '../app_theme_cubit.dart';
import '../entity/page.dart';
import 'settings_page/settings_cubit.dart';
import 'settings_page/settings_page.dart';
import 'home/edit_page/edit_page.dart';
import 'home/home_body.dart';
import 'home/pages_cubit.dart';
import 'tab_cubit.dart';
import 'timeline/timeline_body.dart';
import 'timeline/timeline_cubit.dart';
import 'timeline/timeline_state.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInBack,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold(context);
  }

  Widget _scaffold(BuildContext context) {
    return BlocBuilder<TimelineCubit, TimelineState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).accentColor,
            title: BlocProvider.of<TimelineCubit>(context).state.isOnSearch &&
                    BlocProvider.of<TabCubit>(context).state == 1
                ? TextField(
                    cursorColor: Theme.of(context).textTheme.bodyText2.color,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2.color,
                      fontSize:
                          SettingsCubit.calculateSize(context, 12, 15, 20),
                    ),
                    onChanged:
                        BlocProvider.of<TimelineCubit>(context).setFilter,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .color
                            .withOpacity(0.5),
                        fontSize:
                            SettingsCubit.calculateSize(context, 12, 15, 20),
                      ),
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    BlocProvider.of<TabCubit>(context).state == 0
                        ? 'Home'
                        : 'Timeline',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyText2.color,
                      fontSize:
                          SettingsCubit.calculateSize(context, 15, 20, 30),
                    ),
                  ),
            iconTheme: Theme.of(context).accentIconTheme,
            actions: [
              if (BlocProvider.of<TabCubit>(context).state == 1)
                _searchButton(context),
              if (BlocProvider.of<TabCubit>(context).state == 1)
                _showFavouritesButton(context),
              if (!BlocProvider.of<TimelineCubit>(context).state.isOnSearch)
                _themeChangeButton(context),
            ],
          ),
          drawer: _drawer(context),
          bottomNavigationBar: _bottomNavigationBar(context),
          floatingActionButton: _floatingActionButton(context),
          body: Animator<Offset>(
            repeats: 1,
            resetAnimationOnRebuild: true,
            tween: Tween<Offset>(
              begin: Offset(
                  BlocProvider.of<TabCubit>(context).state == 0 ? -1 : 1, 0.0),
              end: Offset.zero,
            ),
            curve: Curves.easeOutExpo,
            builder: (context, animatorState, child) => SlideTransition(
              position: animatorState.animation,
              child: _body(context),
            ),
          ),
        );
      },
    );
  }

  Widget _showFavouritesButton(BuildContext context) {
    return BlocBuilder<TimelineCubit, TimelineState>(
      builder: (context, state) => IconButton(
        icon: Icon(
          state.showingFavourites ? Icons.star : Icons.star_border_outlined,
        ),
        onPressed:
            BlocProvider.of<TimelineCubit>(context).changeShowingFavourites,
      ),
    );
  }

  Widget _searchButton(BuildContext context) {
    return BlocBuilder<TimelineCubit, TimelineState>(
      builder: (context, state) => IconButton(
        icon: Icon(
          state.isOnSearch ? Icons.close : Icons.search,
        ),
        onPressed: () => BlocProvider.of<TimelineCubit>(context)
            .setOnSearch(!state.isOnSearch),
      ),
    );
  }

  Widget _themeChangeButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        BlocProvider.of<AppThemeCubit>(context).state.usingLightTheme
            ? Icons.wb_sunny_outlined
            : Icons.bedtime_outlined,
      ),
      onPressed: BlocProvider.of<AppThemeCubit>(context).changeTheme,
    );
  }

  Widget _drawer(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).primaryColor,
      ),
      child: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child: Text(
                DateFormat('MMM d, yyyy').format(DateTime.now()),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
              title: Text(
                'Settings',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          label: 'Timeline',
        ),
      ],
      currentIndex: BlocProvider.of<TabCubit>(context).state,
      onTap: BlocProvider.of<TabCubit>(context).setSelected,
      backgroundColor: Theme.of(context).accentColor,
      selectedItemColor: Theme.of(context).textTheme.bodyText2.color,
      unselectedItemColor:
          Theme.of(context).textTheme.bodyText2.color.withOpacity(0.3),
    );
  }

  Widget _floatingActionButton(BuildContext context) => FloatingActionButton(
        foregroundColor: Theme.of(context).textTheme.bodyText2.color,
        onPressed: () async {
          final pageInfo = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditPage(
                JournalPage('New page', 0),
                'New page',
              ),
            ),
          );
          if (pageInfo.isAllowedToSave) {
            BlocProvider.of<PagesCubit>(context).addPage(pageInfo.page);
          }
        },
        backgroundColor: Theme.of(context).accentColor,
        tooltip: 'New page',
        child: Icon(Icons.add),
      );

  Widget _body(BuildContext context) =>
      BlocProvider.of<TabCubit>(context).state == 0
          ? HomeBody()
          : Align(
              child: TimelineBody(),
              alignment: Alignment.bottomCenter,
            );
}
