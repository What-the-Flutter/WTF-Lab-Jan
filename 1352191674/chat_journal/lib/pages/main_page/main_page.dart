import 'package:chat_journal/pages/main_page/main_page_cubit.dart';
import 'package:chat_journal/pages/settings_page/settings_page.dart';
import 'package:chat_journal/services/theme_bloc/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageCubit, MainState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appbar(state, context),
          drawer: _drawer(context),
          body: state.currentPage,
          bottomNavigationBar: _bottomNavbar(context),
        );
      },
    );
  }

  AppBar _appbar(MainState state, context) {
    return AppBar(
      centerTitle: true,
      title: const Text('Home', style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: Icon(
            Icons.opacity,
          ),
          onPressed: () => BlocProvider.of<ThemeCubit>(context).changeTheme(),
        ),
      ],
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 10,
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

  Widget _bottomNavbar(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) =>
          BlocProvider.of<MainPageCubit>(context).setSelectedIndex(index),
      currentIndex: BlocProvider.of<MainPageCubit>(context).state.currentIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_sharp), label: 'Daily'),
        BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Timeline'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
