import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StatesTheme extends Equatable {
  final bool? isLightTheme;
  final ThemeData? themeData;
  final TextTheme? textTheme;

  StatesTheme({this.isLightTheme, this.themeData, this.textTheme});

  StatesTheme copyWith({
    final bool? isLightTheme,
    final ThemeData? themeData,
    final TextTheme? textTheme,
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
        textTheme: textTheme,
        backgroundColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: const IconThemeData(
          color: Colors.deepPurple,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.deepPurple,
          centerTitle: true,
        ),
      ),
      textTheme: textTheme,
    );
  }

  StatesTheme get darkTheme {
    return StatesTheme(
      isLightTheme: false,
      themeData: ThemeData(
        textTheme: textTheme,
        backgroundColor: Colors.black,
        primarySwatch: Colors.yellow,
        brightness: Brightness.dark,
        iconTheme: const IconThemeData(
          color: Colors.yellow,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.yellow,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.yellow,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      textTheme: textTheme,
    );
  }

  static const TextTheme largeTextTheme = TextTheme(
    subtitle1: TextStyle(
      fontSize: 19,
    ),
    bodyText2: TextStyle(
      fontSize: 17,
    ),
    bodyText1: TextStyle(
      fontSize: 18,
    ),
  );

  static const TextTheme defaultTextTheme = TextTheme(
    subtitle1: TextStyle(
      fontSize: 16,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
    ),
  );

  static const TextTheme smallTextTheme = TextTheme(
    subtitle1: TextStyle(
      fontSize: 12,
    ),
    bodyText2: TextStyle(
      fontSize: 10,
    ),
    bodyText1: TextStyle(
      fontSize: 12,
    ),
  );

  @override
  // TODO: implement props
  List<Object?> get props => [isLightTheme, themeData, textTheme];
}
