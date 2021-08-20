import 'package:flutter/material.dart';
import 'Themes/themes.dart';

import 'models/note_model.dart';
import 'screens/home_screen.dart';

List<Notes> notes = [];
List<List<Note>> notesList = [];

List<IconData> listOfIcons = [
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
  return runApp(MyApp());
}

void initTestFields() {
  notesList.add(List<Note>.empty(growable: true));
  notes.add(Notes(title: 'Notes', iconIndex: 0, note: notesList[0]));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: isDarkMode? Themes().darkTheme : Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      home: MainPage(
        isChangedTheme: (value) {
          isDarkMode = value;
          setState(() {});
        },
      ),
    );
  }
}
