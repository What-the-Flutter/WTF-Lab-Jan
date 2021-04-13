import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/shared_preferences_provider.dart';
import 'home_page/home_page.dart';
import 'theme/cubit_theme.dart';
import 'theme/states_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.initialize();
  runApp(
    BlocProvider(
      create: (context) => CubitTheme(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    BlocProvider.of<CubitTheme>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitTheme, StatesTheme>(
      builder: (context, state) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter project',
        theme: state.themeData,
        home: HomePage(),
      ),
    );
  }
}
