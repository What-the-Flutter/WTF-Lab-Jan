import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/create_page/create_cubit.dart';
import 'pages/events_page/event_page_cubit.dart';
import 'pages/home_page/home_page_cubit.dart';
import 'pages/main_page/main_page.dart';
import 'pages/main_page/main_page_cubit.dart';
import 'pages/settings_page/general_settings/general_settings_cubit.dart';
import 'services/db_provider.dart';
import 'services/shared_preferences_provider.dart';
import 'ui/theme_cubit/theme_cubit.dart';
//вынести инициализацию в main cubit или сделать инит кьюбит и инит пейдж и тоже самое с шейред преференсами

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.initialize();
  await DBProvider.initialize();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
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
        BlocProvider(
          create: (context) => GeneralSettingsCubit(),
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
    BlocProvider.of<ThemeCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat Journal',
          themeMode: state.isLight ? ThemeMode.light : ThemeMode.dark,
          theme: state.theme,
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

List<IconData> iconsList = [
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
