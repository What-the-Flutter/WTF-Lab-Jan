import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/shared_preferences_provider.dart';
import 'event_page/events_cubit.dart';
import 'note_page/notes_cubit.dart';
import 'settings/general_settings/background_image_setting/background_image_setting_cubit.dart';
import 'settings/general_settings/general_settings_cubit.dart';
import 'statistics/statistics_page_cubit.dart';
import 'tab_pages/home_page/home_page_cubit.dart';
import 'tab_pages/tab_page.dart';
import 'tab_pages/tab_page_cubit.dart';
import 'tab_pages/timeline_page/filter_page/filter_page_cubit.dart';
import 'tab_pages/timeline_page/filter_page/filter_page_state.dart';
import 'tab_pages/timeline_page/timeline_page_cubit.dart';
import 'theme/theme_cubit.dart';
import 'theme/theme_states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.initialize();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => TabPageCubit(0),
        ),
        BlocProvider(
          create: (context) => TimelinePageCubit(),
        ),
        BlocProvider(
          create: (context) => EventCubit(),
        ),
        BlocProvider(
          create: (context) => HomePageCubit(),
        ),
        BlocProvider(
          create: (context) => NotesCubit(),
        ),
        BlocProvider(
          create: (context) => BackGroundImageSettingCubit(''),
        ),
        BlocProvider(
          create: (context) => GeneralSettingsCubit(),
        ),
        BlocProvider(
          create: (context) => StatisticsPageCubit(),
        ),
        BlocProvider(
          create: (context) => FilterPageCubit(
            FilterPageState(
              noteList: [],
              filterNotesList: [],
              filterLabelList: [],
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
  @override
  void initState() {
    BlocProvider.of<ThemeCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeStates>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat Journal',
          theme: state.theme,
          home: BlocBuilder<TabPageCubit, int>(
            builder: (context, state) {
              return TabPage();
            },
          ),
        );
      },
    );
  }
}
