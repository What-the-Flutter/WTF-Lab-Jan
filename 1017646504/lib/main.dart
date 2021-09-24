import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'color_theme_cubit.dart';
import 'color_theme_state.dart';
import 'data/database_access.dart';
import 'data/preferences_access.dart';
import 'main_page/main_page.dart';
import 'main_page/pages_cubit.dart';
import 'settings_page/settings_cubit.dart';
import 'settings_page/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PreferencesAccess.initialize();
  DatabaseAccess.initialize();
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
          create: (context) => SettingsCubit(SettingsState(false, false)),
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
              home: MainPage(),
            );
          },
        );
      },
    );
  }
}
