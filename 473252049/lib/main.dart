import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'mocks/mocks.dart';
import 'pages/chats_cubit/chats_cubit.dart';
import 'pages/main_page.dart';
import 'thememode_cubit/thememode_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MyApp(
      preferences: await SharedPreferences.getInstance(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;

  const MyApp({Key key, @required this.preferences}) : super(key: key);

  ThemeMode _themeModeFromString(String string) {
    switch (string) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.light;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThememodeCubit(
        _themeModeFromString(
          preferences.getString('themeMode'),
        ),
        preferences: preferences,
      ),
      child: ThemingApp(),
    );
  }
}

class ThemingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThememodeCubit, ThememodeState>(
      builder: (context, state) {
        return MaterialApp(
          title: '473252049',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: state.themeMode,
          home: BlocProvider(
            create: (context) => ChatsCubit(mockCategories),
            child: MainPage(),
          ),
        );
      },
    );
  }
}
