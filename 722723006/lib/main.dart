import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/shared_preferences_provider.dart';
import 'home_page/home_page.dart';
import 'theme/theme_cubit.dart';
import 'theme/theme_states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.initialize();
  runApp(
    BlocProvider(
      create: (context) => ThemeCubit(),
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
    BlocProvider.of<ThemeCubit>(context).initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeStates>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat Journal',
          theme: state.theme,
          home: HomePage(
            title: 'Home',
          ),
        );
      },
    );
  }
}
