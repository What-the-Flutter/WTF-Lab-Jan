import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/data/repository/chat_repository.dart';
import '/data/repository/event_repository.dart';
import '/data/repository/timeline_repository.dart';
import '/screens/chat_screen/chat_screen.dart';
import '/screens/chat_screen/chat_screen_cubit.dart';
import '/screens/filter_screen/filter_screen_cubit.dart';
import '/screens/main_screen/main_screen_cubit.dart';
import '/screens/timeline_screen/timeline_screen.dart';
import '/screens/timeline_screen/timeline_screen_cubit.dart';
import '../add_new_chat/add_new_chat.dart';
import '../add_new_chat/add_new_chat_cubit.dart';
import '../event_screen/event_screen.dart';
import '../event_screen/event_screen_cubit.dart';
import '../settings/settings_cubit.dart';

Widget startApp() {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<EventRepository>(
        create: (context) => EventRepository(),
      ),
      RepositoryProvider<ChatRepository>(
        create: (context) => ChatRepository(),
      ),
      RepositoryProvider<TimelineRepository>(
        create: (context) => TimelineRepository(),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<ChatScreenCubit>(
          create: (context) => ChatScreenCubit(
            RepositoryProvider.of<ChatRepository>(context),
          ),
        ),
        BlocProvider<EventScreenCubit>(
          create: (context) => EventScreenCubit(
            chatRepository: RepositoryProvider.of<ChatRepository>(context),
            eventRepository: RepositoryProvider.of<EventRepository>(context),
          ),
        ),
        BlocProvider<AddNewChatCubit>(
          create: (context) => AddNewChatCubit(
            RepositoryProvider.of<ChatRepository>(context),
          ),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(),
        ),
        BlocProvider<MainScreenCubit>(
          create: (context) => MainScreenCubit(),
        ),
        BlocProvider<TimelineScreenCubit>(
          create: (context) => TimelineScreenCubit(
            RepositoryProvider.of<TimelineRepository>(context),
          ),
        ),
        BlocProvider<FilterScreenCubit>(
          create: (context) => FilterScreenCubit(
            RepositoryProvider.of<EventRepository>(context),
            RepositoryProvider.of<ChatRepository>(context),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List screensList = [
    ChatScreen(),
    ChatScreen(),
    TimelineScreen(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Builder(builder: (context) {
          return BlocBuilder<MainScreenCubit, MainscreenState>(
            builder: (context, state) {
              return MaterialApp(
                routes: {
                  '/add_chat': (context) => const AddNewChat(),
                  '/events': (context) => EventScreen(),
                },
                theme: BlocProvider.of<SettingsCubit>(context).state.theme,
                title: 'Chat Journal',
                home: screensList[BlocProvider.of<MainScreenCubit>(context)
                    .state
                    .selectedTab],
              );
            },
          );
        });
      },
    );
  }
}
