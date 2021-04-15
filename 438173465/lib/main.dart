import 'package:flutter/material.dart';

import 'config/custom_theme.dart';
import 'constants/themes.dart';
import 'my_app.dart';

void main() async {
  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.light,
      child: MyApp(),
    ),
  );
}
