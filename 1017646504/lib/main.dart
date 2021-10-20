import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'color_theme_cubit.dart';
import 'color_theme_state.dart';
import 'data/database_access.dart';
import 'data/preferences_access.dart';
import 'entity/page.dart';
import 'main_pages/home/message_page/messages_cubit.dart';
import 'main_pages/home/message_page/messages_state.dart';
import 'main_pages/home/pages_cubit.dart';
import 'main_pages/settings_page/settings_cubit.dart';
import 'main_pages/settings_page/settings_state.dart';
import 'main_pages/tab_cubit.dart';
import 'main_pages/tab_page.dart';
import 'main_pages/timeline/timeline_cubit.dart';
import 'main_pages/timeline/timeline_state.dart';

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
          create: (context) => ColorThemeCubit(),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(SettingsState(false, false, 0)),
        ),
        BlocProvider(
          create: (context) => TabCubit(0),
        ),
        BlocProvider(
          create: (context) => MessageCubit(MessagesState(JournalPage('Page', 0, creationTime: DateTime.now()))),
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ColorThemeCubit>(context).initialize();
    BlocProvider.of<SettingsCubit>(context).initialize();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return BlocBuilder<ColorThemeCubit, ColorThemeState>(
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
