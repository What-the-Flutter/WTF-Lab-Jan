import 'package:chat_journal/pages/chats_cubit/chats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/theme_mode_bloc/thememode_bloc.dart';
import 'mocks/mocks.dart';
import 'pages/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThememodeBloc(ThemeMode.light),
      child: ThemingApp(),
    );
  }
}

class ThemingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThememodeBloc, ThememodeState>(
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
