import 'package:chat_journal/tab_page/settings_page/labels_page/add_label_page/add_label_cubit.dart';
import 'package:chat_journal/tab_page/settings_page/labels_page/add_label_page/add_label_state.dart';
import 'package:chat_journal/tab_page/settings_page/labels_page/labels_cubit.dart';
import 'package:chat_journal/tab_page/settings_page/labels_page/labels_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme_cubit.dart';
import 'app_theme_state.dart';
import 'data/database_access.dart';
import 'data/preferences_access.dart';
import 'tab_page/home/pages_cubit.dart';
import 'tab_page/settings_page/settings_cubit.dart';
import 'tab_page/settings_page/settings_state.dart';
import 'tab_page/tab_cubit.dart';
import 'tab_page/tab_page.dart';
import 'tab_page/timeline/timeline_cubit.dart';
import 'tab_page/timeline/timeline_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesAccess.initialize();
  await DatabaseAccess.initialize();

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
          create: (context) => SettingsCubit(SettingsState(false, false, 0)),
        ),
        BlocProvider(
          create: (context) => TabCubit(0),
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
        BlocProvider(
          create: (context) => LabelsCubit(LabelsState([])),
        ),
        BlocProvider(
          create: (context) => AddLabelCubit(AddLabelState(0,false)),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AppThemeCubit>(context).initialize();
    BlocProvider.of<SettingsCubit>(context).initialize();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return BlocBuilder<AppThemeCubit, AppThemeState>(
          builder: (context, state) {
            return MaterialApp(
              theme: state.theme,
              home: BlocBuilder<TabCubit, int>(
                builder: (context, state) => TabPage(),
              ),
            );
          },
        );
      },
    );
  }
}
