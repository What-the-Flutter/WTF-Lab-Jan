import 'package:flutter/material.dart';

import 'my_app.dart';
import 'style/custom_theme.dart';
import 'style/themes.dart';

void main() {
  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.light,
      key: UniqueKey(),
      child: MyApp(),
    ),
    //MyApp(),
  );
}
