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
    print('updateShouldNotify');
    return true;
  }
}

class ThemeChanger extends StatefulWidget {
  final Widget child;
  final bool isLight;
  const ThemeChanger({Key? key, required this.child, required this.isLight}) : super(key: key);

  @override
  _ThemeChangerState createState() => _ThemeChangerState();

  static bool of(BuildContext context) => _ThemeChanger.of(context).data.isLight;

  static _ThemeChangerState instanceOf(BuildContext context) => _ThemeChanger.of(context).data;
}

class _ThemeChangerState extends State<ThemeChanger> {
  late bool isLight;

  void changeTheme() => setState(() => isLight = !isLight);

  @override
  void didChangeDependencies() => super.didChangeDependencies();

  @override
  void initState() {
    isLight = widget.isLight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _ThemeChanger(data: this, child: widget.child);
}

ThemeData lightTheme = ThemeData.light();

ThemeData darkTheme = ThemeData.dark();

ThemeData ownTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.grey,
  primarySwatch: Colors.blueGrey,
  dialogBackgroundColor: Colors.blueGrey,
  focusColor: Colors.blueGrey,
  accentColor: Colors.grey,
  backgroundColor: Colors.yellow,
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    foregroundColor: Colors.white,
  ),
  buttonColor: Colors.grey,
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        Colors.red,
      ),
    ),
  ),
);
