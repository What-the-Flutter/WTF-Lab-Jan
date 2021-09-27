import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/create_page/create_page_cubit.dart';
import 'cubit/events/event_cubit.dart';
import 'cubit/home_screen/home_cubit.dart';
import 'cubit/settings/settings_cubit.dart';
import 'cubit/themes/theme_cubit.dart';
import 'cubit/themes/theme_state.dart';
import 'database/shared_preferences_helper.dart';
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

final List<IconData> pagesIcons = <IconData>[
  Icons.favorite,
  Icons.ac_unit,
  Icons.wine_bar,
  Icons.coffee,
  Icons.local_pizza,
  Icons.money,
  Icons.car_rental,
  Icons.food_bank,
  Icons.navigation,
  Icons.laptop,
  Icons.umbrella,
  Icons.access_alarm,
  Icons.accessible,
  Icons.account_balance,
  Icons.account_circle,
  Icons.adb,
  Icons.add_alarm,
  Icons.add_alert,
  Icons.airplanemode_active,
  Icons.attach_money,
  Icons.audiotrack,
  Icons.av_timer,
  Icons.backup,
  Icons.beach_access,
  Icons.block,
  Icons.brightness_1,
  Icons.bug_report,
  Icons.bubble_chart,
  Icons.call_merge,
  Icons.camera,
  Icons.change_history,
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.init();
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider<EventCubit>(create: (context) => EventCubit()),
      BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
      BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
      BlocProvider<CreatePageCubit>(create: (context) => CreatePageCubit()),
      BlocProvider<SettingsCubit>(create: (context) => SettingsCubit()),
    ], child: MyApp()),
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
    BlocProvider.of<SettingsCubit>(context).init();
    BlocProvider.of<HomeCubit>(context).init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeStates>(
      builder: (context, state) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state.themeData,
            home: MainPage(),
            routes: {
              route.noteInfoPage: (context) => NoteInfo(),
              route.addNotePage: (context) => AddNote(),
            });
      },
    );
  }
}
