import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/theme.dart';
import '../../theme/theme_cubit.dart';
import 'settings_cubit.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textStyle = TextStyle(fontSize: 20, color: Colors.white);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return SwitchListTile(
                value: state.themes.isDark,
                onChanged: context.read<ThemeCubit>().changeTheme,
                title: Text(
                  'Dark Theme',
                  style: _textStyle,
                ),
              );
            },
          ),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return Column(
                children: [
                  SwitchListTile(
                    value: state.isBubbleAlignment,
                    onChanged:
                        context.read<SettingsCubit>().changeBubbleAlignment,
                    title: Text(
                      'Bubble Alignment',
                      style: _textStyle,
                    ),
                    subtitle: Text('Changing alignment'),
                  ),
                  SwitchListTile(
                    value: state.isCenterDateBubble,
                    onChanged: context
                        .read<SettingsCubit>()
                        .changeCenterDateAlignmetnt,
                    title: Text(
                      'Center Date Bubble',
                      style: _textStyle,
                    ),
                    subtitle: Text('Centering date in messages'),
                  ),
                  SwitchListTile(
                    value: state.isModifiedDate,
                    onChanged: context.read<SettingsCubit>().changeModifiedDate,
                    title: Text(
                      'Modify Date',
                      style: _textStyle,
                    ),
                    subtitle: Text('You can modify date in chat page'),
                  ),
                  state.isBiometricAuth != null
                      ? SwitchListTile(
                          value: state.isBiometricAuth!,
                          title: Text('Local Authentication'),
                          onChanged:
                              context.read<SettingsCubit>().changeBiometricAuth,
                        )
                      : SwitchListTile(
                          value: false,
                          onChanged: null,
                          title: Text('Local Authentication'),
                          subtitle: Text('device is\'t supported'),
                        )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
