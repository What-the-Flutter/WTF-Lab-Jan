import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_color.dart';

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
    final inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited!.data._themeData;
  }

  static CustomThemeState instanceOf(BuildContext context) {
    final inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited!.data;
  }
}

class CustomThemeState extends State<CustomTheme> {
  ThemeData _themeData = lightTheme;
  late String _changedTheme;

  @override
  void initState() {
    getSharedPrefs();
    super.initState();
  }

  Future<void> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _changedTheme = prefs.getString('theme') ?? 'light';
    _themeData = _changedTheme == 'light' ? lightTheme : darkTheme;
    setState(() {});
  }

  Future<void> changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
      _changedTheme = 'dark';
    } else {
      _themeData = lightTheme;
      _changedTheme = 'light';
    }
    prefs.setString('theme', _changedTheme);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => _CustomTheme(
        data: this,
        child: widget.child,
      );
}
