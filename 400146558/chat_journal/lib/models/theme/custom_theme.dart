import 'package:chat_journal/models/theme/theme_constants.dart';
import 'package:flutter/material.dart';

class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  const _CustomTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class CustomTheme extends StatefulWidget {
  final Widget child;
  final CustomThemeMode themeMode;

  const CustomTheme({
    Key? key,
    required this.themeMode,
    required this.child,
  }) : super(key: key);

  @override
  CustomThemeState createState() => CustomThemeState();

  static ThemeData of(BuildContext context) {
    var inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited!.data._theme;
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
    _theme = MyThemes.getThemeFromMode(widget.themeMode);
    super.initState();
  }

  void changeTheme(CustomThemeMode themeMode) {
    setState(() => _theme = MyThemes.getThemeFromMode(themeMode));
  }

  @override
  Widget build(BuildContext context) {
    return _CustomTheme(
      data: this,
      child: widget.child,
    );
  }
}
