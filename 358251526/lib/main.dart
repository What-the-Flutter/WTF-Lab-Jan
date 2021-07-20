import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_journal/pages/chat_page/chat_page_cubit.dart';
import 'package:my_journal/util/db_provider.dart';

import '../util/shared_preferences_provider.dart';
import 'pages/add_page/add_page_cubit.dart';
import 'pages/home_page/home_page.dart';
import 'pages/home_page/home_page_cubit.dart';
import 'theme_bloc/theme_bloc.dart';
import 'util/domain.dart';

void main() async {
  await SharedPreferencesProvider.initialize();
  await DBProvider.initialize();
  runApp(
    BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(),
      child: BlocProvider<ChatPageCubit>(
        create: (context) => ChatPageCubit(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  @override
  void initState() {
    BlocProvider.of<ThemeBloc>(context).add(
      SetTheme(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddPageCubit(),
      child: BlocProvider(
        create: (context) => HomePageCubit(initialCategories),
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
    );
  }
}
