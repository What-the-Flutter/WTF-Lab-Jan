import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/entity/theme.dart';

import 'theme_provider/theme_cubit.dart';
import 'theme_provider/theme_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState();

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeCubit>().state;
    return Scaffold(
      backgroundColor: theme.colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colors.themeColor1,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _switch((value) => setState(() => context.read<ThemeCubit>().changeThemeColor())),
            const SizedBox(
              height: 15,
            ),
            _fontChooser((size) => setState(() => context.read<ThemeCubit>().changeFontSize(size))),
          ],
        ),
      ),
    );
  }

  Widget _switch(Function(bool value) onChange) {
    final theme = context.read<ThemeCubit>().state;
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Switch(
            activeColor: Colors.yellow.shade200,
            activeTrackColor: Colors.indigo.shade800,
            inactiveThumbColor: Colors.yellow,
            inactiveTrackColor: Colors.lightBlueAccent,
            value: theme.tColor != ThemeColor.light,
            onChanged: (value) => onChange(value),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            'Change Theme',
            style: TextStyle(
              fontSize: theme.fontSize.general + 1,
              color: theme.colors.textColor2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fontChooser(Function(FontSize value) onPressed) {
    final theme = context.read<ThemeCubit>().state;
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _fontSizeOption(
            onPressed: onPressed,
            fontSize: FontSizeSet.defaultSmall,
            title: 'Small',
            fontSizeSet: FontSize.small,
          ),
          const SizedBox(
            width: 5,
          ),
          _fontSizeOption(
            onPressed: onPressed,
            fontSize: FontSizeSet.defaultMedium,
            title: 'Medium',
            fontSizeSet: FontSize.medium,
          ),
          const SizedBox(
            width: 5,
          ),
          _fontSizeOption(
            onPressed: onPressed,
            fontSize: FontSizeSet.defaultLarge,
            title: 'Large',
            fontSizeSet: FontSize.large,
          ),
          const SizedBox(
            width: 25,
          ),
          Text(
            'Change Font Size',
            style: TextStyle(
              fontSize: theme.fontSize.general + 1,
              color: theme.colors.textColor2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fontSizeOption({
    required Function(FontSize value) onPressed,
    required double fontSize,
    required String title,
    required FontSize fontSizeSet,
  }) {
    final theme = context.read<ThemeCubit>().state;
    return GestureDetector(
      child: Text(
        'ABcd',
        style: TextStyle(
          fontSize: fontSize,
          shadows: [
            Shadow(
              color: theme.fSize == fontSizeSet
                  ? theme.colors.yellowAccent
                  : theme.colors.underlineColor,
              offset: const Offset(0, -5),
            )
          ],
          color: Colors.transparent,
          fontWeight: theme.fSize == fontSizeSet ? FontWeight.bold : null,
          decoration: TextDecoration.underline,
          decorationColor:
              theme.fSize == fontSizeSet ? theme.colors.yellowAccent : theme.colors.underlineColor,
          decorationThickness: 4,
        ),
      ),
      onTap: () => onPressed(fontSizeSet),
    );
  }
}
