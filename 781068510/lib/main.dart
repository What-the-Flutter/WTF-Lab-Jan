import 'package:flutter/material.dart';

import 'Themes/theme_change.dart';
import 'Themes/themes.dart';
import 'models/note_model.dart';
import 'routes/routes.dart' as route;

List<Journal> notes = [];

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

void main() {
  initTestFields();
  runApp(
    ThemeSelector(
      theme: Themes().lightTheme,
      child: MyApp(),
    ),
  );
}

void initTestFields() {
  notes.add(
    Journal(
      title: 'Notes',
      iconIndex: 0,
      note: [
        Note(description: 'test', isBookmarked: false, time: '1'),
        Note(description: 'event 1', isBookmarked: false, time: '2'),
        Note(description: 'event 2', isBookmarked: false, time: '3'),
        Note(description: 'run', isBookmarked: false, time: '4'),
        Note(description: 'eat', isBookmarked: false, time: '5'),
        Note(description: 'task 1', isBookmarked: false, time: '6'),
        Note(description: 'task 2', isBookmarked: false, time: '7'),
        Note(description: 'task 3', isBookmarked: false, time: '8'),
        Note(description: 'task 4', isBookmarked: false, time: '9'),
        Note(description: 'task 5', isBookmarked: false, time: '10'),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeSelector.instanceOf(context).theme,
      onGenerateRoute: route.controller,
      initialRoute: route.mainPage,
    );
  }
}
