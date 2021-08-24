import 'package:chat_journal/pages/create_page/create_cubit.dart';
import 'package:chat_journal/pages/events_page/event_page_cubit.dart';
import 'package:chat_journal/pages/home_page/home_page_cubit.dart';
import 'package:chat_journal/pages/main_page/main_page.dart';
import 'package:chat_journal/pages/main_page/main_page_cubit.dart';
import 'package:chat_journal/services/shared_preferences_provider.dart';
import 'package:chat_journal/services/db_provider.dart';
import 'package:chat_journal/services/theme_bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/note_model.dart';
import 'services/my_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.initialize();
  await DBProvider.initialize();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) => MainPageCubit(),
        ),
        BlocProvider(
          create: (context) => HomePageCubit(),
        ),
        BlocProvider(
          create: (context) => NotesCubit(),
        ),
        BlocProvider(
          create: (context) => EventCubit(),
        ),
      ],
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
    BlocProvider.of<ThemeBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat Journal',
          themeMode: state.isLight ? ThemeMode.light : ThemeMode.dark,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: BlocBuilder<MainPageCubit, MainState>(
            builder: (context, state) {
              return MainPage();
            },
          ),
        );
      },
    );
  }
}
List<Note> initialCategories = [];
List<IconData> initialIcons = [
  Icons.family_restroom,
  Icons.work,
  Icons.local_shipping,
  Icons.sports_basketball,
  Icons.wine_bar,
  Icons.accessibility,
  Icons.agriculture,
  Icons.anchor,
  Icons.category,
  Icons.title,
  Icons.airline_seat_flat_rounded,
  Icons.attach_money,
  Icons.attach_file_outlined,
  Icons.auto_fix_high,
  Icons.workspaces_filled,
];
List <IconData>iconsList = [
  Icons.book,
  Icons.import_contacts_outlined,
  Icons.nature_people_outlined,
  Icons.info,
  Icons.mail,
  Icons.ac_unit,
  Icons.access_time,
  Icons.camera_alt,
  Icons.hail,
  Icons.all_inbox,
  Icons.auto_fix_high,
  Icons.workspaces_filled,
  Icons.attach_money,
];
