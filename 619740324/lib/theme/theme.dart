import 'package:flutter/material.dart';

import 'light_theme.dart';

class ThemeSwitcher extends InheritedWidget {
  final _ThemeSwitcherWidgetState data;

  const ThemeSwitcher({Key key, this.data, Widget child})
      : super(key: key, child: child);

  static _ThemeSwitcherWidgetState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ThemeSwitcher>()).data;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return this != oldWidget;
  }
}

class ThemeSwitcherWidget extends StatefulWidget {
  final ThemeData initialTheme;
  final Widget child;

  ThemeSwitcherWidget({Key key, this.initialTheme, this.child})
      : super(key: key);

  @override
  _ThemeSwitcherWidgetState createState() => _ThemeSwitcherWidgetState();
}

class _ThemeSwitcherWidgetState extends State<ThemeSwitcherWidget> {
  ThemeData themeData;
  Color color ;

  void switchTheme(ThemeData themeData) {
    setState(() {
      this.themeData = themeData;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = themeData ?? widget.initialTheme;
    themeData == lightThemeData
    ? color = Colors.blueGrey[100]
    : color = themeData.primaryColor;
    return ThemeSwitcher(
      data: this,
      child: widget.child,
    );
  }
}