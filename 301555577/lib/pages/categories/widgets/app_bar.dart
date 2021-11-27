import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../../utils/theme.dart';

AppBar appBar() {
  return AppBar(
    title: const Text(
      'Sticky Notes',
    ),
    centerTitle: true,
    elevation: 2,
    actions: [
      Builder(builder: (context) {
        return IconButton(
          splashRadius: 20,
          onPressed: () {
            var themeProvider =
                Provider.of<ThemeProvider>(context, listen: false);
            themeProvider.swapTheme();
          },
          icon: const Icon(
            LineIcons.adjust,
          ),
        );
      })
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
