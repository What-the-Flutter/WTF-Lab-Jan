import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_screen/create_cubit.dart';
import 'create_screen/create_page.dart';
import 'event_screen/event_cubit.dart';
import 'home_screen/home_cubit.dart';
import 'home_screen/home_page.dart';
import 'theme/theme_cubit.dart';
import 'theme/theme_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<CreatePageCubit>(create: (context) => CreatePageCubit()),
        BlocProvider<EventCubit>(create: (context) => EventCubit())
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat Diary',
            theme: state.themeData,
            home: HomePage(),
            routes: {'/create-page': (context) => CreatePage()},
          );
        },
      ),
    );
  }
}
