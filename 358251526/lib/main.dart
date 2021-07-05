import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_journal/pages/add_page/add_page_cubit.dart';
import 'package:my_journal/pages/home_page/home_page_cubit.dart';
import 'package:my_journal/theme_bloc/theme_bloc.dart';

import 'domain.dart';
import 'pages/home_page/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddPageCubit(),
      child: BlocProvider(
        create: (context) => HomePageCubit(initialCategories),
        child: BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(true),
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'Home Page',
                themeMode: state.isLight ? ThemeMode.light : ThemeMode.dark,
                theme: lightTheme,
                darkTheme: darkTheme,
                home: HomePage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
