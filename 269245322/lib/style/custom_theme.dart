import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../shared_preferences/sp_settings_helper.dart';
import 'themes.dart';

class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  _CustomTheme({
    required this.data,
    required Key key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomTheme oldWidget) {
    return true;
  }
}

class CustomTheme extends StatefulWidget {
  final Widget child;

  const CustomTheme({
    required Key key,
    required this.child,
  }) : super(key: key);

  @override
  CustomThemeState createState() => CustomThemeState();

  static ThemeData of(BuildContext context) {
    var inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>()!);
    return inherited.data.theme;
  }

  static CustomThemeState instanceOf(BuildContext context) {
    var inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>()!);
    return inherited.data;
  }
}

class CustomThemeState extends State<CustomTheme> {
  late ThemeData _theme;

  ThemeData get theme => _theme;

  @override
  void initState() {
    final _sharedPreferencesProvider = SharedPreferencesProvider();

    (_sharedPreferencesProvider.getTheme() == 0)
        ? _theme = MyThemes.getThemeFromKey(MyThemeKeys.light)
        : _theme = MyThemes.getThemeFromKey(MyThemeKeys.dark);

    super.initState();
  }

  void changeTheme(MyThemeKeys themeKey) {
    setState(() {
      _theme = MyThemes.getThemeFromKey(themeKey);
      final _sharedPreferencesProvider = SharedPreferencesProvider();
      themeKey == MyThemeKeys.light
          ? SharedPreferencesProvider.changeTheme(0)
          : SharedPreferencesProvider.changeTheme(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _CustomTheme(
      data: this,
      key: UniqueKey(),
      child: widget.child,
    );
  }
}
