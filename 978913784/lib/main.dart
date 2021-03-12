import 'package:chat_journal/settings_page/settings_cubit.dart';
import 'package:chat_journal/settings_page/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme_cubit.dart';
import 'app_theme_state.dart';
import 'home_page/home_page.dart';
import 'home_page/pages_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => PagesCubit([]),
      ),
      BlocProvider(
        create: (context) => AppThemeCubit(),
      ),
      BlocProvider(
        create: (context) => SettingsCubit(SettingsState(false,false)),
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
              theme: ThemeData(
                primarySwatch: Colors.deepPurple,
              ),
              home: HomePage(state),
            );
          },
        );
      },
    );
  }
}
