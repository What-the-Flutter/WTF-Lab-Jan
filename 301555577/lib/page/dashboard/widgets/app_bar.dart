import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../../theme/theme.dart';

AppBar appBar() {
  return AppBar(
    title: const Text('Diary'),
    centerTitle: true,
    elevation: 2,
    actions: [
      IconButton(
        splashRadius: 20,
        onPressed: () {
          Themes.statusBarTheme();
          if (Get.isDarkMode) {
            Get.changeThemeMode(ThemeMode.light);
          } else {
            Get.changeThemeMode(ThemeMode.dark);
          }
        },
        icon: const Icon(
          LineIcons.adjust,
        ),
      )
    ],
    leading: Builder(
      builder: (context) {
        return IconButton(
          splashRadius: 20,
          icon: const Icon(
            LineIcons.bars,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    ),
  );
}
