import 'package:flutter/material.dart';

class AppTheme extends StatefulWidget {
  final Widget child;

  AppTheme({this.child, Key key}) : super(key: key);

  @override
  AppThemeState createState() => AppThemeState(child: child);
}

class AppThemeState extends State<AppTheme> {
  final Widget child;

  AppThemeState({this.child});

  @override
  Widget build(BuildContext context) {
    return applyTheme(
      child: child,
    );
  }
}

class AppThemeData extends InheritedWidget {
  static final GlobalKey<AppThemeState> appThemeStateKey = GlobalKey<AppThemeState>();

  static bool usingLightTheme = true;

  final Color mainColor;
  final Color mainTextColor;
  final Color accentColor;
  final Color accentLightColor;
  final Color accentTextColor;
  final Color shadowColor;

  const AppThemeData({
    Key key,
    @required this.mainColor,
    @required this.mainTextColor,
    @required this.accentColor,
    @required this.accentLightColor,
    @required this.accentTextColor,
    @required this.shadowColor,
    @required Widget child,
  })  : assert(child != null),
        assert(mainColor != null),
        assert(mainTextColor != null),
        assert(accentColor != null),
        assert(accentLightColor != null),
        assert(accentTextColor != null),
        assert(shadowColor != null),
        super(key: key, child: child);

  static AppThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppThemeData>();
  }

  @override
  bool updateShouldNotify(AppThemeData old) =>
      mainColor != old.mainColor ||
      mainTextColor != old.mainTextColor ||
      accentColor != old.accentColor ||
      accentTextColor != old.accentTextColor ||
      accentLightColor != old.accentLightColor ||
      shadowColor != old.shadowColor;
}

Widget applyTheme({Widget child}) {
  return AppThemeData.usingLightTheme
      ? lightTheme(child: child)
      : darkTheme(child: child);
}

AppThemeData lightTheme({Widget child}) {
  return AppThemeData(
    mainColor: Colors.white,
    mainTextColor: Colors.black,
    accentColor: Colors.purple.shade900,
    accentLightColor: Colors.purple.shade600,
    accentTextColor: Colors.white,
    shadowColor: Colors.black,
    child: child,
  );
}

AppThemeData darkTheme({Widget child}) {
  return AppThemeData(
    mainColor: Color(0xFF121212),
    mainTextColor: Colors.white,
    accentColor: Colors.purple.shade900,
    accentLightColor: Colors.purple.shade600,
    accentTextColor: Colors.white,
    shadowColor: Colors.deepPurple,
    child: child,
  );
}
