import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/data_provider/journal_database.dart';
import 'data/data_provider/shared_preferences_provider.dart';
import 'data/repository/event_repository.dart';
import 'data/repository/page_repository.dart';
import 'data/repository/settings_repository.dart';
import 'pages/add_page/add_page_cubit.dart';
import 'pages/event_page/event_cubit.dart';
import 'pages/main_page/main_pade_cubit.dart';
import 'pages/main_page/main_page_screen.dart';
import 'pages/settings/settings_cubit.dart';
import 'pages/settings/settings_state.dart';
import 'theme/theme_cubit.dart';
import 'theme/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = JournalDatabase();
  await SharedPreferencesProvider.initialize();
  final pref = SharedPreferencesProvider();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ActivityPageRepository>(
          create: (context) => ActivityPageRepository(db),
        ),
        RepositoryProvider<EventRepository>(
          create: (context) => EventRepository(db),
        ),
        RepositoryProvider<SettingsRepository>(
          create: (context) => SettingsRepository(pref),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeCubit(),
          ),
          BlocProvider(
            create: (context) =>
                SettingsCubit(
                  RepositoryProvider.of<SettingsRepository>(context),
                ),
          ),
          BlocProvider(
            create: (context) =>
                EventCubit(
                  RepositoryProvider.of<EventRepository>(context),
                ),
          ),
          BlocProvider(
            create: (context) =>
                MainPageCubit(
                  RepositoryProvider.of<ActivityPageRepository>(context),
                ),
          ),
          BlocProvider(
            create: (context) =>
                AddPageCubit(
                  RepositoryProvider.of<ActivityPageRepository>(context),
                ),
          ),
        ],
        child: MyApp(),
      ),
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
    super.initState();
    BlocProvider.of<SettingsCubit>(context).initSettings();
    BlocProvider.of<ThemeCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Chat Journal App',
              themeMode: state.isLightTheme ? ThemeMode.dark : ThemeMode.dark,
              theme: state.themeData,
              initialRoute: '/',
              home: MainPageScreen(),
            );
          },
        );
      },
    );
  }
}
