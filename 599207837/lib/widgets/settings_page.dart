import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entity/theme.dart';
import 'alerts.dart';
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
                const SizedBox(
                  height: 15,
                ),
                _bubbleAlignChooser(context.read<ThemeCubit>()),
                const SizedBox(
                  height: 75,
                ),
                _shareButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shareButton(BuildContext context) {
    final theme = context.read<ThemeCubit>().state;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Share',
          style: TextStyle(
            fontSize: theme.fontSize.secondary,
            color: theme.colors.minorTextColor,
          ),
        ),
        IconButton(
          onPressed: () => Alerts.shareAlert(context: context),
          icon: Icon(
            Icons.share_rounded,
            color: theme.colors.textColor1,
            size: 27,
          ),
        ),
        Text(
          'App',
          style: TextStyle(
            fontSize: theme.fontSize.secondary,
            color: theme.colors.minorTextColor,
          ),
        ),
      ],
    );
  }

  Widget _bubbleAlignChooser(ThemeCubit themeCubit) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Change Bubble Alignment',
            style: TextStyle(
              fontSize: themeCubit.state.fontSize.general + 1,
              color: themeCubit.state.colors.textColor2,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _bubbleAlignOption(
                image: Image.asset('assets/images/bubble_left_${themeCubit.state.tColor.name}.jpg'),
                themeCubit: themeCubit,
                alignment: MainAxisAlignment.start,
              ),
              _bubbleAlignOption(
                image: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child:
                      Image.asset('assets/images/bubble_left_${themeCubit.state.tColor.name}.jpg'),
                ),
                themeCubit: themeCubit,
                alignment: MainAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bubbleAlignOption({
    required Widget image,
    required ThemeCubit themeCubit,
    required MainAxisAlignment alignment,
  }) {
    return Column(
      children: [
        Center(
          child: Radio<MainAxisAlignment>(
            value: alignment,
            groupValue: themeCubit.state.bubbleAlignment,
            fillColor: MaterialStateProperty.all(themeCubit.state.colors.underlineColor),
            onChanged: (value) => themeCubit.changeBubbleAlignment(value!),
          ),
        ),
        Container(
          height: 105,
          width: 140,
          decoration: BoxDecoration(
            border: Border.all(
              color: themeCubit.state.colors.textColor1,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            child: image,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
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
