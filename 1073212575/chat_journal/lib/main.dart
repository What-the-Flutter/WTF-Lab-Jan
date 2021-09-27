import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme/custom_theme.dart';
import 'pages/add_page/add_page_cubit.dart';
import 'pages/event_page/event_page_cubit.dart';
import 'pages/home_page/home_page_cubit.dart';
import 'pages/home_page/home_page_screen.dart';
import 'theme/themes.dart';

void main() {
  runApp(
    CustomTheme(
      themeData: lightTheme,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomePageCubit>(
            create: (context) => HomePageCubit(),
          ),
          BlocProvider<EventPageCubit>(
            create: (context) => EventPageCubit(),
          ),
          BlocProvider<AddPageCubit>(
            create: (context) => AddPageCubit(),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}
