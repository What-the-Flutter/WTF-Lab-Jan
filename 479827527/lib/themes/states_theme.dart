import 'package:flutter/material.dart';

class StatesTheme {
  final bool isLightTheme;
  final ThemeData themeData;
  final TextTheme textTheme;

  const StatesTheme({this.isLightTheme, this.themeData, this.textTheme});

  StatesTheme copyWith({
    final bool isLightTheme,
    final ThemeData themeData,
    final TextTheme textTheme,
  }) {
    return StatesTheme(
      isLightTheme: isLightTheme ?? this.isLightTheme,
      themeData: themeData ?? this.themeData,
      textTheme: textTheme ?? this.textTheme,
    );
  }

  StatesTheme get lightTheme {
    return StatesTheme(
      isLightTheme: true,
      themeData: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(
          color: Colors.deepPurple,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromRGBO(30, 144, 255, 100),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.deepPurple,
          centerTitle: true,
        ),
        textTheme: textTheme,
      ),
      textTheme: textTheme,
    );
  }

  StatesTheme get darkTheme {
    return StatesTheme(
      isLightTheme: false,
      themeData: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.orangeAccent,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.orangeAccent,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.orangeAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
        ),
        textTheme: textTheme,
      ),
      textTheme: textTheme,
    );
  }

  static const TextTheme largeTextTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 22,
    ),
    headline2: TextStyle(
      fontSize: 22,
    ),
    headline3: TextStyle(
      fontSize: 22,
    ),
    headline4: TextStyle(
      fontSize: 22,
    ),
    headline5: TextStyle(
      fontSize: 22,
    ),
    headline6: TextStyle(
      fontSize: 22,
    ),
    subtitle1: TextStyle(
      fontSize: 17,
    ),
    subtitle2: TextStyle(
      fontSize: 17,
    ),
    bodyText1: TextStyle(
      fontSize: 19,
    ),
    bodyText2: TextStyle(
      fontSize: 19,
    ),
  );

  static const TextTheme defaultTextTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 20,
    ),
    headline2: TextStyle(
      fontSize: 20,
    ),
    headline3: TextStyle(
      fontSize: 20,
    ),
    headline4: TextStyle(
      fontSize: 20,
    ),
    headline5: TextStyle(
      fontSize: 20,
    ),
    headline6: TextStyle(
      fontSize: 20,
    ),
    subtitle1: TextStyle(
      fontSize: 15,
    ),
    subtitle2: TextStyle(
      fontSize: 15,
    ),
    bodyText1: TextStyle(
      fontSize: 17,
    ),
    bodyText2: TextStyle(
      fontSize: 17,
    ),
  );

  static const TextTheme smallTextTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 14,
    ),
    headline2: TextStyle(
      fontSize: 14,
    ),
    headline3: TextStyle(
      fontSize: 14,
    ),
    headline4: TextStyle(
      fontSize: 14,
    ),
    headline5: TextStyle(
      fontSize: 14,
    ),
    headline6: TextStyle(
      fontSize: 14,
    ),
    subtitle1: TextStyle(
      fontSize: 12,
    ),
    subtitle2: TextStyle(
      fontSize: 12,
    ),
    bodyText1: TextStyle(
      fontSize: 13,
    ),
    bodyText2: TextStyle(
      fontSize: 13,
    ),
  );
}
