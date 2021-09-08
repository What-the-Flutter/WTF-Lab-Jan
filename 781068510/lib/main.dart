import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/cubit/create_page/create_page_cubit.dart';
import 'package:notes/database/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Themes/theme_change.dart';
import 'Themes/themes.dart';
import 'cubit/events/event_cubit.dart';
import 'cubit/home_screen/home_cubit.dart';
import 'cubit/themes/theme_cubit.dart';
import 'routes/routes.dart' as route;
import 'screens/add_note_page/add_note_page.dart';
import 'screens/event_page/note_info_page.dart';
import 'screens/home_screen_page/home_screen.dart';

List<Page> notes = [];

List<IconData> listOfEventsIcons = [
  Icons.cancel,
  Icons.movie,
  Icons.sports_basketball,
  Icons.sports_outlined,
  Icons.local_laundry_service,
  Icons.fastfood,
  Icons.run_circle_outlined,
];

List<String> listOfEventsNames = [
  'Cancel',
  'Movie',
  'Sports',
  'Workout',
  'Laundry',
  'FastFood',
  'Running',
];

List<IconData> listOfIcons = [
  Icons.text_fields,
  Icons.coffee,
  Icons.cake,
  Icons.star,
  Icons.vpn_key_sharp,
  Icons.work_outlined,
  Icons.flight_takeoff,
  Icons.hotel,
  Icons.call,
  Icons.laptop,
  Icons.shop,
  Icons.wallet_giftcard,
  Icons.music_note,
  Icons.car_rental
];

var theme;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  theme = await ThemePreferences.init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)  {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventCubit>(create: (context) => EventCubit()),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<CreatePageCubit>(create: (context) => CreatePageCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state,
            // theme: theme == 1 ? Themes().darkTheme : Themes().lightTheme,
            home: MainPage(),
            routes: {
              route.noteInfoPage : (context) => NoteInfo(),
              route.addNotePage : (context) => AddNote(),
            }
          );
        },
      ),
    );
  }
}
