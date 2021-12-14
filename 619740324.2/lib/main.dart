import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pages/create_page/cubit_create_page.dart';
import 'pages/event_page/cubit_event_page.dart';

import 'pages/home_page/cubit_home_page.dart';
import 'pages/home_page/home_page.dart';
import 'theme/light_theme.dart';
import 'theme/theme.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<CubitEventPage>(
          create: (context) => CubitEventPage(),
        ),
        BlocProvider<CubitHomePage>(
          create: (context) => CubitHomePage(),
        ),
        BlocProvider<CubitCreatePage>(
          create: (context) => CubitCreatePage(),
        ),
      ],
      child: ThemeSwitcherWidget(
        child: const MyApp(),
        initialTheme: lightThemeData,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter project',
      theme: ThemeSwitcher.of(context)?.themeData,
      home: HomePage(),
    );
  }
}
