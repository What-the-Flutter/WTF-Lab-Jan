import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'cubit/settings_cubit.dart';

class GeneralSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Settings'),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        bloc: context.read<SettingsCubit>(),
        builder: (context, state) {
          return ListView.separated(
            itemBuilder: (context, index) {
              return SwitchListTile(
                title: Text('Dark mode'),
                subtitle: Text('Enables and disables dark theme mode'),
                onChanged: (value) {
                  context.read<SettingsCubit>().switchThemeMode();
                },
                value: state.themeMode == ThemeMode.dark,
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: 1,
          );
        },
      ),
    );
  }
}
