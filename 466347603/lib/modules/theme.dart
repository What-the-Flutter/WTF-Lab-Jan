import 'package:flutter/material.dart';

class StatefulCustomTheme extends StatefulWidget {
  final ThemeData themeData;
  final Widget child;

  const StatefulCustomTheme({
    Key? key,
    required this.child,
    required this.themeData,
  }) : super(key: key);

  @override
  StatefulCustomThemeState createState() => StatefulCustomThemeState();
}

class StatefulCustomThemeState extends State<StatefulCustomTheme> {
  ThemeData themeData = CustomTheme.light;

  void changeTheme() {
    setState(() {
      if (themeData == CustomTheme.light) {
        themeData = CustomTheme.dark;
      } else {
        themeData = CustomTheme.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) => InheritedCustomTheme(
        themeData: widget.themeData,
        child: widget.child,
        state: this,
      );
}

class InheritedCustomTheme extends InheritedWidget {
  final ThemeData themeData;
  final StatefulCustomThemeState state;

  InheritedCustomTheme({
    Key? key,
    required Widget child,
    required this.themeData,
    required this.state,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedCustomTheme oldThemeData) => true;

  static StatefulCustomThemeState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedCustomTheme>()!.state;
}

// ignore: avoid_classes_with_only_static_members
class CustomTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF006766),
    accentColor: const Color(0xFFFFD741),
    cardColor: const Color(0xFF78909C),
    selectedRowColor: const Color(0xFFBCE3C6),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFFAFAFA),
      selectedItemColor: Color(0xFF006766),
    ),
    primaryTextTheme: const TextTheme(
      bodyText1: TextStyle(
        color: Color(0xFF0A0A0A),
        fontSize: 18,
      ),
      headline6: TextStyle(
        color: Color(0xFFFDFFFE),
      ),
      subtitle2: TextStyle(
        color: Color(0xFF737478),
        fontSize: 18,
      ),
    ),
    primaryIconTheme: const IconThemeData(
      color: Color(0xFFFDFFFE),
    ),
    accentIconTheme: const IconThemeData(
      color: Color(0xFF006766),
    ),
    backgroundColor: const Color(0xFFF5F5F5),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    dialogBackgroundColor: const Color(0xFFE4F2E3),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF213244),
    accentColor: const Color(0xFFFFD741),
    cardColor: const Color(0xFF2E353F),
    selectedRowColor: const Color(0xFF3D4753),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E2832),
      selectedItemColor: Color(0xFFFFD741),
    ),
    primaryTextTheme: const TextTheme(
      bodyText1: TextStyle(
        color: Color(0xFFFDFFFE),
        fontSize: 18,
      ),
      headline6: TextStyle(
        color: Color(0xFFFDFFFE),
      ),
      subtitle2: TextStyle(
        color: Color(0xFF737478),
        fontSize: 18,
      ),
    ),
    primaryIconTheme: const IconThemeData(
      color: Color(0xFFFDFFFE),
    ),
    accentIconTheme: const IconThemeData(
      color: Color(0xFFFDFFFE),
    ),
    backgroundColor: const Color(0xFF343E48),
    scaffoldBackgroundColor: const Color(0xFF1E2832),
    dialogBackgroundColor: const Color(0xFF2C353E),
  );
}
