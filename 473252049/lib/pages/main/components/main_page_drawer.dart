import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../category/cubit/records_cubit.dart';
import '../../search_record_page.dart';
import '../../settings/settings_page.dart';
import '../../statistics/statistics_page.dart';
import '../tabs/home/cubit/categories_cubit.dart';

class MainPageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                DateFormat.yMMMMEEEEd().format(
                  DateTime.now(),
                ),
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          shareAppDrawerItem(),
          searchDrawerItem(context),
          drawerItem(Icons.notifications, 'Notifications', () {}),
          statisticsDrawerItem(context: context),
          drawerItem(
            Icons.settings,
            'Settings',
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (newContext) {
                    return BlocProvider.value(
                      value: context.read<CategoriesCubit>(),
                      child: SettingsPage(),
                    );
                  },
                ),
              );
            },
          ),
          feedbackDrawerItem(),
        ],
      ),
    );
  }
}

Widget statisticsDrawerItem({BuildContext context}) {
  return ListTile(
    title: Text('Statistics'),
    leading: Icon(Icons.data_usage_outlined),
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return StatisticsPage();
          },
        ),
      );
    },
  );
}

Widget drawerItem(IconData icon, String text, void Function() onTap) {
  return ListTile(
    title: Text(text),
    leading: Icon(icon),
    onTap: onTap,
  );
}

Widget shareAppDrawerItem() {
  return ListTile(
    title: Text('Share app'),
    leading: Icon(Icons.share),
    onTap: () {
      Share.share(
          'I recommend you to check out this app! Developer is https://instagram.com/ilyinmus',
          subject: "It'll change your life");
    },
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
              withCategories: true,
            ),
          );
        },
      );
    },
  );
}

Widget feedbackDrawerItem() {
  return ListTile(
    leading: Icon(Icons.email),
    title: Text('Feedback'),
    onTap: () {
      sendEmailToDeveloper();
    },
  );
}

void sendEmailToDeveloper() async {
  await canLaunch(
    developerMailUri.toString(),
  )
      ? await launch(
          developerMailUri.toString(),
        )
      : throw 'Could not launch $developerMailUri';
}

final developerMailUri = Uri(
  scheme: 'mailto',
  path: 'ilyindeveloper@gmail.com',
  queryParameters: {
    'subject': 'ChatJournal',
  },
);
