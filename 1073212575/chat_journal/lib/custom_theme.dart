import 'package:flutter/material.dart';
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
  late ThemeData _themeData;

  ThemeData get theme => _themeData;

  @override
  void initState() {
    _themeData = lightTheme;
    super.initState();
  }

  void changeTheme() {
    setState(() {
      _themeData == lightTheme
          ? _themeData = darkTheme
          : _themeData = lightTheme;
    });
  }

  @override
  Widget build(BuildContext context) => _CustomTheme(
        data: this,
        child: widget.child,
      );
}
