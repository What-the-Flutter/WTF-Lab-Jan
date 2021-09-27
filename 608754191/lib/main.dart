import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/add_page/add_page.dart';
import 'pages/add_page/add_page_cubit.dart';
import 'pages/entity/category.dart';
import 'pages/home_page/home_page.dart';
import 'pages/home_page/home_page_cubit.dart';
import 'pages/navbar_pages/timeline_page/timeline_page.dart';
import 'util/theme_bloc/theme_cubit.dart';
import 'util/theme_inherited/application_theme.dart';

List<Category> initialCategories = [
  Category('Travel', Icons.airport_shuttle_sharp, []),
  Category('Family', Icons.family_restroom_sharp, []),
  Category('Sports', Icons.directions_bike, []),
];

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
void main() => runApp(
      ChatJournal(),
    );

class ChatJournal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddPageCubit(),
      child: BlocProvider(
        create: (context) => HomePageCubit(initialCategories),
        child: BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(true),
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'Home Page',
                themeMode: state.isLight ? ThemeMode.light : ThemeMode.dark,
                theme: lightTheme,
                darkTheme: darkTheme,
                routes: {
                  '/home_page': (_) => ChatJournalHomePage(initialCategories),
                  '/add_page': (_) => AddPage.add(),
                  '/timeline_page': (_) => TimelinePage(categories: initialCategories),
                },
                initialRoute: '/home_page',
              );
            },
          ),
        ),
      ),
    );
  }
}
