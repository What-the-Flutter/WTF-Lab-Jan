import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:flutter/widgets.dart';

class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  _CustomTheme({
    required Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomTheme oldWidget) {
    return true;
  }
}

class CustomTheme extends StatefulWidget {
  final Widget child;
  final myThemes initialThemeKey;

  CustomTheme({required this.child, required this.initialThemeKey});

  @override
  CustomThemeState createState() => new CustomThemeState();

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
  late ThemeData _theme;

  ThemeData get theme => _theme;

  @override
  void initState() {
    _theme = Themes.getThemeFromKey(widget.initialThemeKey);
    super.initState();
  }

  void changeTheme(myThemes themeKey) {
    setState(() {
      _theme = Themes.getThemeFromKey(themeKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _CustomTheme(
      data: this,
      key: widget.key,
      child: widget.child,
    );
  }
}
