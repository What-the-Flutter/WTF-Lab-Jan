import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'themes.dart';

class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  _CustomTheme({
    required this.data,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class CustomTheme extends StatefulWidget {
  final Widget child;
  final ThemeData themeData;

  const CustomTheme({
    Key? key,
    required this.themeData,
    required this.child,
  }) : super(key: key);

  @override
  CustomThemeState createState() => CustomThemeState();

  static ThemeData of(BuildContext context) {
    var inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited!.data.theme;
  }

  static CustomThemeState instanceOf(BuildContext context) {
    var inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited!.data;
  }
}

class CustomThemeState extends State<CustomTheme> {
  ThemeData _themeData = lightTheme;
  var _savedTheme;

  ThemeData get theme => _themeData;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<void> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _savedTheme = prefs.getString('theme') ?? 'light';
    _themeData = (_savedTheme == 'light' ? lightTheme : darkTheme);
    //_themeData = lightTheme;
  }

  Future<void> changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_themeData == lightTheme) {
        _themeData = darkTheme;
        _savedTheme = 'dark';
      } else {
        _themeData = lightTheme;
        _savedTheme = 'light';
      }
    });
    prefs.setString('theme', _savedTheme);
  }

  @override
  Widget build(BuildContext context) => _CustomTheme(
        data: this,
        child: widget.child,
      );
}
