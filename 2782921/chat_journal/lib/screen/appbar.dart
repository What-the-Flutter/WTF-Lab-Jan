import 'package:flutter/material.dart';
import 'theme/custom_theme.dart';
import 'theme/theme.dart';

class SimilarScreenTop extends StatelessWidget with PreferredSizeWidget {
  SimilarScreenTop({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _changeTheme(BuildContext buildContext, myThemes key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  bool darktheme = true;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Align(
        child: Text('HOME'),
        alignment: Alignment.center,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
          ),
          child: GestureDetector(
            onTap: () {
              if (darktheme) {
                _changeTheme(context, myThemes.dark);
                darktheme = !darktheme;
              } else {
                _changeTheme(context, myThemes.light);
                darktheme = !darktheme;
              }
            },
            child: const Icon(
              Icons.nightlight_round,
              size: 24.0,
            ),
          ),
        ),
      ],
    );
  }
}
