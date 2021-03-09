import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'mocks/mocks.dart';
import 'pages/chats_cubit/chats_cubit.dart';
import 'pages/main_page.dart';
import 'thememode_cubit/thememode_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThememodeCubit(ThemeMode.light),
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
