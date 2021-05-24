import 'package:flutter/material.dart';

import 'themes_model.dart';

class ThemeChanger extends InheritedWidget {
  final _ThemeSwitcherState data;

  ThemeChanger({Key? key, required Widget child, required this.data})
      : super(key: key, child: child);

  static _ThemeSwitcherState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeChanger>();
    return result!.data;
  }

  @override
  bool updateShouldNotify(covariant ThemeChanger oldWidget) =>
      this != oldWidget;
}

class ThemeSwitcher extends StatefulWidget {
  final ThemeData initialTheme;
  final Widget child;

  ThemeSwitcher({Key? key, required this.initialTheme, required this.child})
      : super(key: key);

  @override
  _ThemeSwitcherState createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  ThemeData? themeData;

  void switchTheme(Themes themes) {
    setState(() {
      themeData = MyTheme.chooseTheme(themes);
    });
  }

  bool isDark() {
    if (themeData == null) throw 'theme is null';
    if (themeData == MyTheme.chooseTheme(Themes.light)) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = themeData ?? widget.initialTheme;
    return ThemeChanger(
      data: this,
      child: widget.child,
    );
  }
}
