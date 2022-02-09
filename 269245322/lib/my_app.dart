import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/home/home.dart';
import 'pages/page/custom_page.dart';
import 'pages/page_constructor/page_constructor.dart';
import 'pages/settings/settings.dart';
import 'style/theme_cubit.dart';
import 'style/theme_state.dart';

class MyApp extends StatelessWidget {
  final ThemeCubit _themeCubit = ThemeCubit();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
        bloc: _themeCubit, builder: _buildWithTheme);
  }

  Widget _buildWithTheme(BuildContext context, ThemeState state) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        PageConstructor.routeName: (context) => PageConstructor(),
        CustomPage.routeName: (context) => CustomPage(),
        SettingsPage.routeName: (context) =>
            SettingsPage(themeCubit: _themeCubit),
      },
      theme: state.themeData,
    );
  }
}
