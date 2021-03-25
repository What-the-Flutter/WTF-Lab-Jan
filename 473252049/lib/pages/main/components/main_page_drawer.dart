import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../category/cubit/records_cubit.dart';
import '../../search_record_page.dart';
import '../../settings/settings_page.dart';

class MainPageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Drawer Header'),
          ),
          drawerItem(Icons.card_giftcard, 'Help spread the world', () {}),
          searchDrawerItem(context),
          drawerItem(Icons.notifications, 'Notifications', () {}),
          drawerItem(Icons.whatshot, 'Statistics', () {}),
          drawerItem(
            Icons.settings,
            'Settings',
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
          drawerItem(Icons.feedback, 'Feedback', () {}),
        ],
      ),
    );
  }
}

Widget drawerItem(IconData icon, String text, void Function() onTap) {
  return ListTile(
    title: Text(text),
    leading: Icon(icon),
    onTap: onTap,
  );
}

Widget searchDrawerItem(BuildContext context) {
  return BlocBuilder<RecordsCubit, RecordsState>(
    builder: (context, state) {
      return ListTile(
        leading: Icon(Icons.search),
        title: Text('Search'),
        onTap: () {
          context.read<RecordsCubit>().loadRecords();
          showSearch(
            context: context,
            delegate: SearchRecordPage(
              context: context,
              records: state.records,
            ),
          );
        },
      );
    },
  );
}
