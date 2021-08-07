import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
