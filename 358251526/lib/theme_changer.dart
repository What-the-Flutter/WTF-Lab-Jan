import 'package:flutter/material.dart';

class _ThemeChanger extends InheritedWidget {
  final _ThemeChangerState data;

  const _ThemeChanger({
    required this.data,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  static _ThemeChanger of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<_ThemeChanger>();
    assert(result != null, 'No ThemeChanger found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_ThemeChanger old) {
    return true;
  }
}

class ThemeChanger extends StatefulWidget {
  final Widget child;
  final bool isLight;

  const ThemeChanger({
    Key? key,
    required this.child,
    required this.isLight,
  }) : super(key: key);

  @override
  _ThemeChangerState createState() => _ThemeChangerState();

  static bool of(BuildContext context) {
    return _ThemeChanger.of(context).data.isLight;
  }

  static _ThemeChangerState instanceOf(BuildContext context) {
    return _ThemeChanger.of(context).data;
  }
}

class _ThemeChangerState extends State<ThemeChanger> {
  late bool isLight;

  void changeTheme() {
    setState(() {
      isLight = !isLight;
    });
  }

  @override
  void initState() {
    isLight = widget.isLight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeChanger(
      data: this,
      child: widget.child,
    );
  }
}
