import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorTheme extends StatefulWidget {
  final Widget child;

  ColorTheme({required this.child, required Key key}) : super(key: key);

  @override
  ColorThemeState createState() => ColorThemeState(child: child);
}

class ColorThemeState extends State<ColorTheme> {
  final Widget child;

  ColorThemeState({required this.child});

  @override
  Widget build(BuildContext context) {
    return applyTheme(
      child: child,
    );
  }
}

class ColorThemeData extends InheritedWidget {
  static final GlobalKey<ColorThemeState> appThemeStateKey = GlobalKey<ColorThemeState>();

  static bool usingLightTheme = true;

  final Color mainColor;
  final Color mainTextColor;
  final Color accentColor;
  final Color accentLightColor;
  final Color accentTextColor;
  final Color shadowColor;

  const ColorThemeData({
    Key? key,
    required this.mainColor,
    required this.mainTextColor,
    required this.accentColor,
    required this.accentLightColor,
    required this.accentTextColor,
    required this.shadowColor,
    required Widget child,
  }) : super(key: key, child: child);

  static ColorThemeData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ColorThemeData>();
  }

  @override
  bool updateShouldNotify(ColorThemeData old) =>
      mainColor != old.mainColor ||
      mainTextColor != old.mainTextColor ||
      accentColor != old.accentColor ||
      accentTextColor != old.accentTextColor ||
      accentLightColor != old.accentLightColor ||
      shadowColor != old.shadowColor;
}

Widget applyTheme({required Widget child}) {
  return ColorThemeData.usingLightTheme ? lightTheme(child: child) : darkTheme(child: child);
}

ColorThemeData lightTheme({required Widget child}) {
  return ColorThemeData(
    mainColor: Colors.blue.shade200,
    mainTextColor: Colors.black,
    accentColor: Colors.blue.shade700,
    accentLightColor: Colors.blue.shade900,
    accentTextColor: Colors.white,
    shadowColor: Colors.black,
    child: child,
  );
}

ColorThemeData darkTheme({required Widget child}) {
  return ColorThemeData(
    mainColor: const Color(0xFF121212),
    mainTextColor: Colors.white,
    accentColor: Colors.blue.shade800,
    accentLightColor: Colors.blue.shade900,
    accentTextColor: Colors.white,
    shadowColor: Colors.deepPurpleAccent,
    child: child,
  );
}
