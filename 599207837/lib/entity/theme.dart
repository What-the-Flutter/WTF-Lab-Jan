import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Theme {
  final List<ColorSet> _colorSets = [];
  late ColorSet colors;
  late int themeNo;
  static SharedPreferences? _preferences;

  Theme({required this.colors}) {
    themeNo = _preferences?.getInt('theme') ?? 0;
    _colorSets.add(colors);
  }

  Theme.defaultOne() {
    themeNo = _preferences?.getInt('theme') ?? 0;
    _colorSets.add(ColorSet.lightDefault());
    _colorSets.add(ColorSet.darkDefault());
    colors = _colorSets[themeNo];
  }

  static Future<void> lookUpToPreferences() async {
    WidgetsFlutterBinding.ensureInitialized();
    _preferences = await SharedPreferences.getInstance();
  }

  void changeTheme() {
    themeNo = (themeNo + 1) % _colorSets.length;
    _preferences!.setInt('theme', themeNo);
    colors = _colorSets[themeNo];
  }
}

class ColorSet {
  late Color avatarColor;
  late Color underlineColor;
  late Color minorTextColor;
  Color? backgroundColor;
  Color? themeColor1;
  Color? themeColor2;
  Color? iconColor1;
  Color? iconColor2;
  Color? buttonColor;
  Color? textColor1;
  Color? textColor2;
  Color? redTextColor;
  Color? greenTextColor;
  Color? blueTextColor;
  Color? chatTaskColor;
  Color? chatEventColor;
  Color? chatNoteColor;

  ColorSet({
    required this.avatarColor,
    required this.underlineColor,
    required this.minorTextColor,
    this.backgroundColor,
    this.themeColor1,
    this.themeColor2,
    this.iconColor1,
    this.iconColor2,
    this.buttonColor,
    this.textColor1,
    this.textColor2,
    this.redTextColor,
    this.greenTextColor,
    this.blueTextColor,
    this.chatTaskColor,
    this.chatEventColor,
    this.chatNoteColor,
  });

  ColorSet.lightDefault() {
    avatarColor = Colors.blue;
    backgroundColor = Colors.white;
    themeColor1 = Colors.blue;
    themeColor2 = const Color.fromARGB(5, 5, 5, 5);
    iconColor1 = Colors.black26;
    iconColor2 = Colors.black;
    buttonColor = Colors.blue;
    textColor1 = Colors.black;
    textColor2 = Colors.black;
    minorTextColor = Colors.grey.shade600;
    redTextColor = Colors.redAccent.shade100;
    greenTextColor = Colors.teal;
    blueTextColor = Colors.blue;
    chatTaskColor = Colors.lightGreen.shade200;
    chatEventColor = Colors.cyan.shade200;
    chatNoteColor = Colors.grey.shade200;
    underlineColor = Colors.blue;
  }

  ColorSet.darkDefault() {
    avatarColor = const Color.fromARGB(255, 60, 60, 60);
    backgroundColor = const Color.fromARGB(255, 33, 33, 33);
    themeColor1 = const Color.fromARGB(255, 48, 48, 48);
    themeColor2 = const Color.fromARGB(255, 38, 38, 38);
    iconColor1 = const Color.fromARGB(255, 189, 189, 189);
    iconColor2 = const Color.fromARGB(255, 213, 213, 213);
    buttonColor = const Color.fromARGB(255, 60, 60, 60);
    textColor1 = const Color.fromARGB(255, 213, 213, 213);
    textColor2 = Colors.white;
    minorTextColor = Colors.grey.shade600;
    redTextColor = Colors.yellow;
    greenTextColor = const Color.fromARGB(255, 174, 255, 90);
    blueTextColor = const Color.fromARGB(255, 15, 222, 233);
    chatTaskColor = const Color.fromARGB(255, 70, 135, 70);
    chatEventColor = const Color.fromARGB(255, 50, 115, 120);
    chatNoteColor = const Color.fromARGB(255, 66, 66, 66);
    underlineColor = const Color.fromARGB(255, 189, 189, 189);
  }
}
