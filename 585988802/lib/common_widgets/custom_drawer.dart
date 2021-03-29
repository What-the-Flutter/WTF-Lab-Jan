import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/font_size_customization.dart';
import '../screens/creating_categories_screen/creating_categories_screen.dart';
import '../screens/setting_screen/settings_screen.dart';
import '../screens/setting_screen/settings_screen_bloc.dart';
import '../theme/theme_bloc.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: BlocProvider.of<ThemeBloc>(context).state ==
                        ThemeMode.dark
                    ? [Colors.deepPurpleAccent.shade200, Colors.purpleAccent]
                    : [Colors.deepOrangeAccent, Colors.red],
              ),
            ),
            accountName: Text(
              'Alex',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    BlocProvider.of<ThemeBloc>(context).state == ThemeMode.dark
                        ? Theme.of(context).accentColor
                        : Theme.of(context).primaryColor,
              ),
            ),
            accountEmail: Text(
              'shevelyanchik01@mail.ru',
              style: TextStyle(
                color:
                    BlocProvider.of<ThemeBloc>(context).state == ThemeMode.dark
                        ? Theme.of(context).accentColor
                        : Theme.of(context).primaryColor,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text(
              'Search',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: BlocProvider.of<SettingScreenBloc>(context)
                            .state
                            .fontSize ==
                        0
                    ? listTileTitleSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? listTileTitleDefaultFontSize
                        : listTileTitleLargeFontSize,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.widgets_outlined),
            title: Text(
              'Categories',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: BlocProvider.of<SettingScreenBloc>(context)
                            .state
                            .fontSize ==
                        0
                    ? listTileTitleSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? listTileTitleDefaultFontSize
                        : listTileTitleLargeFontSize,
              ),
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatingCategoriesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.timeline),
            title: Text(
              'Timeline',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: BlocProvider.of<SettingScreenBloc>(context)
                            .state
                            .fontSize ==
                        0
                    ? listTileTitleSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? listTileTitleDefaultFontSize
                        : listTileTitleLargeFontSize,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: BlocProvider.of<SettingScreenBloc>(context)
                            .state
                            .fontSize ==
                        0
                    ? listTileTitleSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? listTileTitleDefaultFontSize
                        : listTileTitleLargeFontSize,
              ),
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
          Divider(
            color: Colors.black54,
            height: 0.5,
            thickness: 0.5,
            indent: 15,
            endIndent: 15,
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text(
              'Notifications',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: BlocProvider.of<SettingScreenBloc>(context)
                            .state
                            .fontSize ==
                        0
                    ? listTileTitleSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? listTileTitleDefaultFontSize
                        : listTileTitleLargeFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
