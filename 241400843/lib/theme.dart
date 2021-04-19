import 'package:flutter/material.dart';

class AppTheme extends StatefulWidget {
  Widget Function(BuildContext context, Brightness brightness) builder;

  AppTheme({this.builder});

  @override
  _AppThemeState createState() => _AppThemeState();

  static _AppThemeState of(BuildContext context) {
    return context.findAncestorStateOfType<_AppThemeState>();
  }
}

class _AppThemeState extends State<AppTheme> {
  Brightness _brightness;

  @override
  void initState() {
    super.initState();
    _brightness = Brightness.light;
  }

  void changeTheme() {
    setState(() {
      _brightness =
          _brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _brightness);
  }
}
