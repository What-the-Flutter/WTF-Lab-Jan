import 'package:flutter/material.dart';

class Theme {
  late final List<Color> _backgroundColor;
  late final List<Color> _themeColor1;
  late final List<Color> _themeColor2;
  late final List<Color> _iconColor1;
  late final List<Color> _buttonColor;
  late final List<Color> _textColor1;
  late final List<Color> _textColor2;
  late final List<Color> _redTextColor;
  late final List<Color> _greenTextColor;
  late final List<Color> _blueTextColor;
  late final List<Color> _chatTaskColor;
  late final List<Color> _chatEventColor;
  late final List<Color> _chatNoteColor;
  late final List<Color> _underlineColor;

  late Color avatarColor1;
  late Color backgroundColor;
  late Color themeColor1;
  late Color themeColor2;
  late Color iconColor1;
  late Color iconColor2;
  late Color buttonColor;
  late Color textColor1;
  late Color textColor2;
  late Color redTextColor;
  late Color greenTextColor;
  late Color blueTextColor;
  late Color chatTaskColor;
  late Color chatEventColor;
  late Color chatNoteColor;
  late Color underlineColor;

  late int theme;

  Theme();

  Theme.defaultOne() {
    _backgroundColor = [Colors.white, const Color.fromARGB(255, 33, 33, 33)];
    _themeColor1 = [Colors.blue, const Color.fromARGB(255, 48, 48, 48)];
    _themeColor2 = [const Color.fromARGB(5, 5, 5, 5), const Color.fromARGB(255, 38, 38, 38)];
    _iconColor1 = [Colors.black26, const Color.fromARGB(255, 189, 189, 189)];
    _buttonColor = [Colors.blue, const Color.fromARGB(255, 60, 60, 60)];
    _textColor1 = [Colors.black, const Color.fromARGB(255, 213, 213, 213)];
    _textColor2 = [Colors.black, Colors.white];
    _redTextColor = [Colors.redAccent.shade100, Colors.yellow];
    _greenTextColor = [Colors.teal, const Color.fromARGB(255, 174, 255, 90)];
    _blueTextColor = [Colors.blue, const Color.fromARGB(255, 15, 222, 2332)];
    _chatTaskColor = [Colors.lightGreen.shade200, const Color.fromARGB(255, 70, 135, 70)];
    _chatEventColor = [Colors.cyan.shade200, const Color.fromARGB(255, 50, 115, 120)];
    _chatNoteColor = [Colors.grey.shade200, const Color.fromARGB(255, 66, 66, 66)];
    _underlineColor = [Colors.blue, const Color.fromARGB(255, 189, 189, 189)];

    backgroundColor = _backgroundColor[0];
    themeColor1 = _themeColor1[0];
    themeColor2 = _themeColor2[0];
    iconColor1 = _iconColor1[0];
    buttonColor = _buttonColor[0];
    textColor1 = _textColor1[0];
    textColor2 = _textColor2[0];
    redTextColor = _redTextColor[0];
    greenTextColor = _greenTextColor[0];
    blueTextColor = _blueTextColor[0];
    chatTaskColor = _chatTaskColor[0];
    chatEventColor = _chatEventColor[0];
    chatNoteColor = _chatNoteColor[0];
    underlineColor = _underlineColor[0];

    avatarColor1 = _buttonColor[0];
    iconColor2 = _textColor1[0];
    theme = 0;
  }

  void changeTheme() {
    theme = (theme + 1) % _backgroundColor.length;
    backgroundColor = _backgroundColor[theme];
    themeColor1 = _themeColor1[theme];
    themeColor2 = _themeColor2[theme];
    iconColor1 = _iconColor1[theme];
    buttonColor = _buttonColor[theme];
    textColor1 = _textColor1[theme];
    textColor2 = _textColor2[theme];
    redTextColor = _redTextColor[theme];
    greenTextColor = _greenTextColor[theme];
    blueTextColor = _blueTextColor[theme];
    chatTaskColor = _chatTaskColor[theme];
    chatEventColor = _chatEventColor[theme];
    chatNoteColor = _chatNoteColor[theme];
    underlineColor = _underlineColor[theme];

    avatarColor1 = _buttonColor[theme];
    iconColor2 = _textColor1[theme];
  }
}