import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/event_repository.dart';
import 'data/page_repository.dart';
import 'pages/add_page/add_page_cubit.dart';
import 'pages/event_page/event_cubit.dart';
import 'pages/main_page/main_pade_cubit.dart';
import 'pages/main_page/main_page_screen.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ActivityPageRepository>(
          create: (context) => ActivityPageRepository(),
        ),
        RepositoryProvider<EventRepository>(
          create: (context) => EventRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                EventCubit(
                  RepositoryProvider.of<EventRepository>(context),
                ),
          ),
          BlocProvider(
            create: (context) =>
                MainPageCubit(
                  RepositoryProvider.of<ActivityPageRepository>(context),
                ),
          ),
          BlocProvider(
            create: (context) =>
                PageCubit(
                  RepositoryProvider.of<ActivityPageRepository>(context),
                ),
          ),
        ],
        child: MaterialApp(
          title: 'Chat Journal App',
          initialRoute: '/',
          home: MainPageScreen(),
        ),
      ),
    ),
  );
}