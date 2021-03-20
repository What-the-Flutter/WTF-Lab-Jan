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
          return ListView(
            children: [
              SwitchListTile(
                title: Text('Dark mode'),
                subtitle: Text('Enables and disables dark theme mode'),
                onChanged: (value) {
                  context.read<SettingsCubit>().switchThemeMode();
                },
                value: state.themeMode == ThemeMode.dark,
              ),
              SwitchListTile(
                title: Text('Center date bubble'),
                subtitle: Text('Date bubble will be placed to center'),
                value: state.centerDateBubble,
                onChanged: (value) {
                  context.read<SettingsCubit>().switchCenterDateBubble();
                },
              ),
              ListTile(
                title: Text('Bubble alignment'),
                subtitle: Text('Right or left alignment of bubbles'),
                trailing: Icon(
                  state.bubbleAlignment == Alignment.centerRight
                      ? Icons.format_align_right
                      : Icons.format_align_left,
                ),
                onTap: () {
                  context.read<SettingsCubit>().switchBubbleAlignment();
                },
              ),
              SwitchListTile(
                title: Text('Show create record date time picker'),
                subtitle: Text(
                    "When you'll create record, you can choose date and time of this event"),
                value: state.showCreateRecordDateTimePicker,
                onChanged: (value) {
                  context
                      .read<SettingsCubit>()
                      .switchShowCreateRecordDateTimePicker();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

final settingsListTiles = [];
