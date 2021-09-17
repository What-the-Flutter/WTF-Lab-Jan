import 'package:flutter/material.dart';

import 'pages/add_page/add_page.dart';
import 'pages/entity/category.dart';
import 'pages/home_page/home_page.dart';
import 'pages/navbar_pages/timeline_page/timeline_page.dart';
import 'util/application_theme.dart';

List<Category> initialCategories = [
  Category('Travel', _titleForBlankScreen, Icons.airport_shuttle_sharp, []),
  Category('Family', _titleForBlankScreen, Icons.family_restroom_sharp, []),
  Category('Sports', _titleForBlankScreen, Icons.directions_bike, []),
];

List<IconData> icons = [
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

final String _titleForBlankScreen = 'No events. Click to create one';

class ChatJournal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeChanger(
      isLight: true,
      child: Builder(
        builder: (context) => MaterialApp(
          title: 'ChatJournal',
          theme: ThemeChanger.of(context) ? lightTheme : darkTheme,
          routes: {
            '/home_page': (_) => ChatJournalHomePage(initialCategories),
            '/add_page': (_) => AddPage.add(),
            '/timeline_page': (_) => TimelinePage(categories: initialCategories)
          },
          initialRoute: '/home_page',
        ),
      ),
    );
  }
}
