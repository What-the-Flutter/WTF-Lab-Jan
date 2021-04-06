import 'package:chat_journal/data/database_access.dart';
import 'package:chat_journal/data/icon_list.dart';
import 'package:chat_journal/data/preferences_access.dart';
import 'package:chat_journal/tab_page/statistics/statistics_cubit.dart';
import 'package:chat_journal/tab_page/statistics/statistics_state.dart';
import 'package:chat_journal/tab_page/tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme_cubit.dart';
import 'app_theme_state.dart';
import 'entity/page.dart';
import 'labels_cubit.dart';
import 'tab_page/home/event_page/events_cubit.dart';
import 'tab_page/home/event_page/events_state.dart';
import 'tab_page/home/pages_cubit.dart';
import 'tab_page/settings_page/labels_page/add_label_page/add_label_cubit.dart';
import 'tab_page/settings_page/labels_page/add_label_page/add_label_state.dart';
import 'tab_page/settings_page/settings_cubit.dart';
import 'tab_page/settings_page/settings_state.dart';
import 'tab_page/tab_cubit.dart';
import 'tab_page/tab_page.dart';
import 'tab_page/timeline/timeline_cubit.dart';
import 'tab_page/timeline/timeline_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseAccess.initialize();
  await PreferencesAccess.initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PagesCubit([]),
        ),
        BlocProvider(
          create: (context) => AppThemeCubit(),
        ),
        BlocProvider(
          create: (context) => LabelsCubit(stockLabels),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(SettingsState(false, false, 0)),
        ),
        BlocProvider(
          create: (context) => TabCubit(
            TabState(-1, 0),
          ),
        ),
        BlocProvider(
          create: (context) => EventCubit(EventsState(JournalPage('Page', 0))),
        ),
        BlocProvider(
          create: (context) => StatisticsCubit(StatisticsState('Today',[],[],[])),
        ),
        BlocProvider(
          create: (context) => TimelineCubit(
            TimelineState(
              false,
              false,
              false,
              false,
              '',
              [],
            ),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initData() async {
    BlocProvider.of<AppThemeCubit>(context).initialize();
    BlocProvider.of<SettingsCubit>(context).initialize();
    BlocProvider.of<LabelsCubit>(context).initialize();
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return BlocBuilder<AppThemeCubit, AppThemeState>(
          builder: (context, state) {
            return MaterialApp(
              theme: state.theme,
              home: BlocBuilder<TabCubit, TabState>(
                builder: (context, state) => TabPage(),
              ),
            );
          },
        );
      },
    );
  }
}
