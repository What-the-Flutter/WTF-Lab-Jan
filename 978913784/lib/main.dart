import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme_cubit.dart';
import 'app_theme_state.dart';
import 'data/database_access.dart';
import 'data/preferences_access.dart';
import 'home_page/home_page.dart';
import 'home_page/pages_cubit.dart';
import 'settings_page/settings_cubit.dart';
import 'settings_page/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesAccess.initialize();
  await DatabaseAccess.initialize();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => PagesCubit([]),
      ),
      BlocProvider(
        create: (context) => AppThemeCubit(),
      ),
      BlocProvider(
        create: (context) => SettingsCubit(SettingsState(false,false, 0)),
      ),
    ],
    child: MyApp(),
  ));
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
              home: HomePage(),
            );
          },
        );
      },
    );
  }
}
