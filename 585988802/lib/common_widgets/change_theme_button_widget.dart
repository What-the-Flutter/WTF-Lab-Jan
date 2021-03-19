import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme_bloc.dart';
import '../theme/theme_event.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: BlocProvider.of<ThemeBloc>(context).state == ThemeMode.dark,
      onChanged: (value) {
        BlocProvider.of<ThemeBloc>(context).add(
          ChangeThemeEvent(),
        );
      },
      activeThumbImage: AssetImage('assets/images/dark_theme.png'),
      inactiveThumbImage: AssetImage('assets/images/light_theme.png'),
    );
  }
}
