import 'package:flutter/material.dart';

import 'Themes/theme_change.dart';
import 'Themes/themes.dart';
import 'models/note_model.dart';
import 'routes/routes.dart' as route;


List<Journal> notes = [];
List<List<Note>> notesList = [];

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
  runApp(MyApp()); //remove?
  runApp(
    ThemeSelector(
      theme: Themes().lightTheme,
      child: MyApp(),
    ),
  );
}

void initTestFields() {
  notesList.add(List<Note>.empty(growable: true));
  notes.add(Journal(title: 'Notes', iconIndex: 0, note: notesList[0]));
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
