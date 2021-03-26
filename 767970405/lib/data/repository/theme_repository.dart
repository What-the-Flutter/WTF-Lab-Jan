import 'package:flutter/material.dart';
import '../theme/custom_theme.dart';

class ThemeRepository {
  final List<CustomTheme> themes = <CustomTheme>[
    CustomTheme(
      chatPreviewTheme: ChatPreviewTheme(
        titleStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
        ),
        contentStyle: TextStyle(
            fontSize: 16,
            color: Colors.black.withOpacity(0.4),
        ),
      ),
      botTheme: BotTheme(
        contentStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        iconColor: Colors.black,
        backgroundColor: Colors.green[50],
      ),
      categoryTheme: CategoryTheme(
        backgroundColor: Colors.teal[200],
        iconColor: Colors.white,
      ),
      messageTheme: MessageTheme(
        selectedColor: Colors.green[200],
        unselectedColor: Colors.green[50],
        timeStyle: TextStyle(
          color: Colors.black.withOpacity(0.4),
          fontSize: 16,
        ),
        contentStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      dateTimeModButtonTheme: DateTimeModButtonTheme(
        backgroundColor: Colors.red[50],
        iconColor: Colors.white,
        dateStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      labelDateTheme: LabelDateTheme(
        backgroundColor: Colors.red,
        dateStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      helpWindowTheme: HelpWindowTheme(
          backgroundColor: Colors.green[50],
          titleStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
          contentStyle: TextStyle(
            fontSize: 16,
            color: Colors.black.withOpacity(0.4),
          )
      ),
      appTheme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.teal,
        accentColor: Colors.amberAccent,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        fontFamily: 'Roboto',
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
        ),
      ),
    ),
    CustomTheme(
      chatPreviewTheme: ChatPreviewTheme(
        titleStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
        contentStyle: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      botTheme: BotTheme(
        contentStyle: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        iconColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      categoryTheme: CategoryTheme(
        backgroundColor: Colors.teal[200],
        iconColor: Colors.white,
      ),
      messageTheme: MessageTheme(
        selectedColor: Colors.orangeAccent,
        unselectedColor: Colors.black,
        timeStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        contentStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      dateTimeModButtonTheme: DateTimeModButtonTheme(
        backgroundColor: Colors.red[50],
        iconColor: Colors.white,
        dateStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      labelDateTheme: LabelDateTheme(
        backgroundColor: Colors.red,
        dateStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      helpWindowTheme: HelpWindowTheme(
          backgroundColor: Colors.black,
          titleStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
          contentStyle: TextStyle(
            fontSize: 16,
            color: Colors.white,
          )
      ),
      appTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.amberAccent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
        ),
      ),
    ),
  ];
}
