import 'package:flutter/material.dart';

import 'models/note_model.dart';
import 'screens/home_screen.dart';

List<String> titles = ['Home', 'Daily', 'Timeline', 'Explore'];

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
  notesList.add(List<Note>.empty(growable: true));
  notesList.add(List<Note>.empty(growable: true));

  notes.add(Notes(title: 'Notes', iconIndex: 0, note: notesList[0]));
  notes.add(Notes(title: 'Gratitude', iconIndex: 1, note: notesList[1]));
  notes.add(Notes(title: 'Journal', iconIndex: 2, note: notesList[2]));

  notes[0].note?.add(Note(time: '12:23', isBookmarked: false, description: 'Third note ! :)'));
  notes[0].note?.add(Note(time: '12:24', isBookmarked: false, description: 'Second note ! :)'));
  notes[0].note?.add(Note(time: '12:25', isBookmarked: false, description: 'First note ! :)'));
  // print(notes[1].note?[0].description);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.yellowAccent,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.yellowAccent,
            unselectedItemColor: Colors.black),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        accentColor: Colors.yellowAccent,
        primaryColorLight: Colors.yellowAccent,
      ),
      home: MainPage(),
    );
  }
}
