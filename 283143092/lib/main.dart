import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/theme_bloc.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocProvider(
        create: (context) => ThemeBloc(false),
        child: BlocBuilder<ThemeBloc, bool>(
          builder: (context, isDarkTheme) {
            return MaterialApp(
              title: 'Chat Journal',
              themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
              theme: Themes.lightTheme,
              darkTheme: Themes.darkTheme,
              home: const HomePage(),
            );
          },
        ),
      );
}
