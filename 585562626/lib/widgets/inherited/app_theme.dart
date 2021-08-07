import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../utils/themes.dart';

class AppTheme extends InheritedWidget {
  final bool isDarkMode;
  final ThemeData theme;
  final Function switchTheme;

  AppTheme({Key? key, required Widget child, required this.theme, required this.switchTheme})
      : isDarkMode = theme == darkTheme,
        super(key: key, child: child);

  static AppTheme of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    assert(result != null, 'No AppTheme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppTheme old) {
    return old.theme != theme;
  }
}

class RootWidget extends StatefulWidget {
  final Widget child;

  const RootWidget({Key? key, required this.child}) : super(key: key);

  @override
  _RootWidgetState createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  late ThemeData theme;

  void switchTheme() {
    setState(() {
      if (theme == darkTheme) {
        theme = lightTheme;
      } else {
        theme = darkTheme;
      }
    });
  }

  @override
  void initState() {
    var brightness = SchedulerBinding.instance?.window.platformBrightness;
    var darkModeOn = brightness == Brightness.dark;
    theme = darkModeOn ? lightTheme : darkTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      child: widget.child,
      theme: theme,
      switchTheme: switchTheme,
    );
  }
}
