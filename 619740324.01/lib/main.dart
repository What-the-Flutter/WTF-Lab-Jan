import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/cubit_auth.dart';
import 'data/shared_preferences_provider.dart';
import 'pages/create_page/cubit_create_page.dart';
import 'pages/event_page/cubit_event_page.dart';
import 'pages/home_page/cubit_home_page.dart';
import 'pages/home_page/home_page.dart';
import 'pages/settings_page/cubit_general_settings.dart';
import 'theme/cubit_theme.dart';
import 'theme/states_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesProvider.initialize();
  await Firebase.initializeApp();
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
        BlocProvider<CubitTheme>(
          create: (context) => CubitTheme(),
        ),
        BlocProvider<CubitAuth>(
          create: (context) => CubitAuth(),
        ),
        BlocProvider<CubitGeneralSettings>(
          create: (context) => CubitGeneralSettings(),
        ),
      ],
      child: const MyApp(),
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
  void initState() {
    super.initState();
    BlocProvider.of<CubitTheme>(context).init();
    BlocProvider.of<CubitAuth>(context).signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitTheme, StatesTheme>(
      builder: (context, state) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter project',
        theme: state.themeData,
        home: AnimatedSplashScreen(
          duration: 3000,
          splash: const Text(
            'WTF-Lab-Jan\n Chat Journal',
          ),
          nextScreen: HomePage(),
          splashTransition: SplashTransition.sizeTransition,
          backgroundColor: Colors.cyan,
        ),
      ),
    );
  }
}
