import 'package:flutter/material.dart';

class ColorSet {
  Color avatarColor;
  Color underlineColor;
  Color minorTextColor;
  Color backgroundColor;
  Color themeColor1;
  Color themeColor2;
  Color iconColor1;
  Color iconColor2;
  Color buttonColor;
  Color textColor1;
  Color textColor2;
  Color redTextColor;
  Color greenTextColor;
  Color blueTextColor;
  Color chatTaskColor;
  Color chatEventColor;
  Color chatNoteColor;
  Color yellowAccent;

  ColorSet({
    required this.avatarColor,
    required this.underlineColor,
    required this.minorTextColor,
    required this.backgroundColor,
    required this.themeColor1,
    required this.themeColor2,
    required this.iconColor1,
    required this.iconColor2,
    required this.buttonColor,
    required this.textColor1,
    required this.textColor2,
    required this.redTextColor,
    required this.greenTextColor,
    required this.blueTextColor,
    required this.chatTaskColor,
    required this.chatEventColor,
    required this.chatNoteColor,
    required this.yellowAccent,
  });

  ColorSet.lightDefault()
      : this(
          avatarColor: Colors.blue,
          backgroundColor: Colors.white,
          themeColor1: Colors.blue,
          themeColor2: const Color.fromARGB(5, 5, 5, 5),
          iconColor1: Colors.black26,
          iconColor2: Colors.black,
          buttonColor: Colors.blue,
          textColor1: Colors.black,
          textColor2: Colors.black,
          minorTextColor: Colors.grey.shade600,
          redTextColor: Colors.redAccent.shade100,
          greenTextColor: Colors.teal,
          blueTextColor: Colors.blue,
          chatTaskColor: Colors.lightGreen.shade200,
          chatEventColor: Colors.cyan.shade200,
          chatNoteColor: Colors.grey.shade200,
          underlineColor: Colors.blue,
          yellowAccent: Colors.yellow,
        );

  ColorSet.darkDefault()
      : this(
          avatarColor: const Color.fromARGB(255, 60, 60, 60),
          backgroundColor: const Color.fromARGB(255, 33, 33, 33),
          themeColor1: const Color.fromARGB(255, 48, 48, 48),
          themeColor2: const Color.fromARGB(255, 38, 38, 38),
          iconColor1: const Color.fromARGB(255, 189, 189, 189),
          iconColor2: const Color.fromARGB(255, 213, 213, 213),
          buttonColor: const Color.fromARGB(255, 60, 60, 60),
          textColor1: const Color.fromARGB(255, 213, 213, 213),
          textColor2: Colors.white,
          minorTextColor: Colors.grey.shade600,
          redTextColor: Colors.yellow,
          greenTextColor: const Color.fromARGB(255, 174, 255, 90),
          blueTextColor: const Color.fromARGB(255, 15, 222, 233),
          chatTaskColor: const Color.fromARGB(255, 70, 135, 70),
          chatEventColor: const Color.fromARGB(255, 50, 115, 120),
          chatNoteColor: const Color.fromARGB(255, 66, 66, 66),
          underlineColor: const Color.fromARGB(255, 189, 189, 189),
          yellowAccent: Colors.yellow.shade200,
        );
}

class FontSizeSet {
  static double defaultSmall = 10;
  static double defaultMedium = 14;
  static double defaultLarge = 18;

  double general;
  double secondary;
  double primary;

  FontSizeSet({required this.general, required this.secondary, required this.primary});

  FontSizeSet.small()
      : this(
          general: defaultSmall,
          secondary: defaultSmall,
          primary: defaultSmall + 2,
        );

  FontSizeSet.medium()
      : this(
          general: defaultMedium,
          secondary: defaultMedium - 1,
          primary: defaultMedium + 2,
        );

  FontSizeSet.large()
      : this(
          general: defaultLarge,
          secondary: defaultLarge - 2,
          primary: defaultLarge + 2,
        );
}
