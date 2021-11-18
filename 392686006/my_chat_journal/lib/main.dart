import 'package:flutter/material.dart';

import 'presentation/pages/app.dart';
import 'presentation/res/styles.dart';

void main() {
  final app = CustomThemeModel(
    child: const App(),
    themeData: CustomTheme.light,
  );
  runApp(app);
}
