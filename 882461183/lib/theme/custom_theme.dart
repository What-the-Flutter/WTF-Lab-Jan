import 'package:flutter/material.dart';
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
    return inherited!.data.themeData;
  }

  static CustomThemeState instanceOf(BuildContext context) {
    final inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited!.data;
  }
}

class CustomThemeState extends State<CustomTheme> {
  late ThemeData themeData;

  @override
  void initState() {
    themeData = lightTheme;
    super.initState();
  }

  void changeTheme() {
    setState(() {
      themeData == lightTheme ? themeData = darkTheme : themeData = lightTheme;
    });
  }

  @override
  Widget build(BuildContext context) => _CustomTheme(
        data: this,
        child: widget.child,
      );
}
