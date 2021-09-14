import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorTheme extends StatefulWidget {
  final Widget child;

  ColorTheme({required this.child, required Key key}) : super(key: key);

  @override
  ColorThemeState createState() => ColorThemeState(child: child);
}

class ColorThemeState extends State<ColorTheme> {
  final Widget child;

  bool usingLightTheme = true;

  ColorThemeState({required this.child});

  @override
  void initState() {
    _loadBool();
    super.initState();
  }

  void _loadBool() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => usingLightTheme = prefs.getBool('usingLightTheme') ?? true);
  }

  @override
  Widget build(BuildContext context) {
    _loadBool();
    return applyTheme(
      usingLightTheme: usingLightTheme,
      child: child,
    );
  }
}

class ColorThemeData extends InheritedWidget {
  static final GlobalKey<ColorThemeState> appThemeStateKey = GlobalKey<ColorThemeState>();

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

Widget applyTheme({required Widget child, required bool usingLightTheme}) {
  return usingLightTheme ? lightTheme(child: child) : darkTheme(child: child);
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
