import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/cubit/settings/settings_cubit.dart';

import '../../utils/utils.dart';
import '../settings/settings_page.dart';

class BuildDrawer extends StatelessWidget {
  late final double textState;

  @override
  Widget build(BuildContext context) {
    textState =
        BlocProvider.of<SettingsCubit>(context).state.textSize.toDouble();
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(90),
        bottomRight: Radius.circular(90),
      ),
      child: Container(
        padding: const EdgeInsets.only(
          right: 1,
          top: 0,
          bottom: 0,
        ),
        color: Theme.of(context).colorScheme.secondary,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(90),
            bottomRight: Radius.circular(90),
          ),
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  // decoration: BoxDecoration(
                  //   color: Theme.of(context).accentColor,
                  // ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      '${getMonthName()} ${DateTime.now().day}, ${DateTime.now().year}',
                      style: TextStyle(
                          fontSize: textState + 3, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.card_giftcard),
                  title: Text(
                    'Help you spread the word',
                    style: TextStyle(
                      fontSize: textState,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: Text(
                    'Search',
                    style: TextStyle(
                      fontSize: textState,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: textState,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.analytics),
                  title: Text(
                    'Statistics',
                    style: TextStyle(
                      fontSize: textState,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: textState,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.feedback),
                  title: Text(
                    'Feedback',
                    style: TextStyle(
                      fontSize: textState,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
