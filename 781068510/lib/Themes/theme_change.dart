import 'package:flutter/material.dart';

import 'themes.dart';

class InheritedTheme extends InheritedWidget {
  final _ThemeSelector data;

  InheritedTheme({
    required this.data,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class ThemeSelector extends StatefulWidget {
  final Widget child;
  final ThemeData theme;

  const ThemeSelector({
    Key? key,
    required this.theme,
    required this.child,
  }) : super(key: key);

  @override
  _ThemeSelector createState() => _ThemeSelector();

  static ThemeData of(BuildContext context) {
    var inherited =
        (context.dependOnInheritedWidgetOfExactType<InheritedTheme>());
    return inherited!.data.theme;
  }

  static _ThemeSelector instanceOf(BuildContext context) {
    var inherited =
        (context.dependOnInheritedWidgetOfExactType<InheritedTheme>());
    return inherited!.data;
  }
}

class _ThemeSelector extends State<ThemeSelector> {
  late ThemeData _theme;

  ThemeData get theme => _theme;

  @override
  void initState() {
    _theme = Themes().lightTheme;
    super.initState();
  }

  void changeTheme() {
    setState(() {
      _theme == Themes().lightTheme
          ? _theme = Themes().darkTheme
          : _theme = Themes().lightTheme;
    });
  }

  @override
  Widget build(BuildContext context) => InheritedTheme(
        data: this,
        child: widget.child,
      );
}
