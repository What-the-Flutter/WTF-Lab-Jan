import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../entity/theme.dart';

import 'theme_provider/theme_cubit.dart';
import 'theme_provider/theme_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SettingsPage();
  }
}

class _SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: state.colors.backgroundColor,
          appBar: AppBar(
            backgroundColor: state.colors.themeColor1,
            title: const Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              _resetButton(
                onTap: () => context.read<ThemeCubit>().resetSettings(),
                theme: state,
              ),
            ],
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _switch((value) => context.read<ThemeCubit>().changeThemeColor(), state),
                const SizedBox(
                  height: 15,
                ),
                _fontChooser((size) => context.read<ThemeCubit>().changeFontSize(size), state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _switch(Function(bool value) onChange, ThemeState theme) {
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

  Widget _fontChooser(Function(FontSize value) onPressed, ThemeState theme) {
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
            theme: theme,
          ),
          const SizedBox(
            width: 5,
          ),
          _fontSizeOption(
            onPressed: onPressed,
            fontSize: FontSizeSet.defaultMedium,
            title: 'Medium',
            fontSizeSet: FontSize.medium,
            theme: theme,
          ),
          const SizedBox(
            width: 5,
          ),
          _fontSizeOption(
            onPressed: onPressed,
            fontSize: FontSizeSet.defaultLarge,
            title: 'Large',
            fontSizeSet: FontSize.large,
            theme: theme,
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
    required ThemeState theme,
  }) {
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

  Widget _resetButton({required Function onTap, required ThemeState theme}) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(right: 5),
        child: GestureDetector(
          onTap: () => onTap(),
          child: Text(
            'Reset',
            style: TextStyle(
              fontSize: theme.fontSize.general,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
