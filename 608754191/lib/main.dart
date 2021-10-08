import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/add_page/add_page.dart';
import 'pages/add_page/add_page_cubit.dart';
import 'pages/entity/category.dart';
import 'pages/home_page/home_page.dart';
import 'pages/home_page/home_page_cubit.dart';
import 'pages/navbar_pages/timeline_page/timeline_page.dart';
import 'util/theme_bloc/theme_cubit.dart';
import 'util/theme_inherited/application_theme.dart';

List<IconData> initialIcons = [
  Icons.theater_comedy,
  Icons.family_restroom,
  Icons.work,
  Icons.local_shipping,
  Icons.sports_basketball,
  Icons.wine_bar,
  Icons.face_unlock_sharp,
  Icons.photo_camera,
  Icons.mode_edit,
  Icons.circle,
  Icons.volunteer_activism,
  Icons.square_foot_rounded,
  Icons.visibility_rounded,
  Icons.accessibility,
  Icons.agriculture,
  Icons.anchor,
  Icons.category,
  Icons.title,
  Icons.airline_seat_flat_rounded,
  Icons.attach_money,
  Icons.attach_file_outlined,
  Icons.auto_fix_high,
  Icons.airplanemode_active,
  Icons.radar,
  Icons.library_music_outlined,
  Icons.wb_sunny,
  Icons.gesture,
  Icons.train_outlined
];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChatJournal(
      preferences: await SharedPreferences.getInstance(),
    ),
  );
}

class ChatJournal extends StatelessWidget {
  final SharedPreferences preferences;

  const ChatJournal({Key? key, required this.preferences}) : super(key: key);

  ThemeMode _themeModeFromString(String? string) {
    switch (string) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.light;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddPageCubit(),
        ),
        BlocProvider(
          create: (context) => HomePageCubit(),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(
            _themeModeFromString(
              preferences.getString(
                'themeMode',
              ),
            ),
            preferences: preferences,
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Home Page',
            themeMode: state.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            routes: {
              '/home_page': (__) => ChatJournalHomePage(),
              '/add_page': (_) => AddPage.add(),
              '/timeline_page': (_) => TimelinePage(categories: []),
            },
            initialRoute: '/home_page',
          );
        },
      ),
    );
  }
}
