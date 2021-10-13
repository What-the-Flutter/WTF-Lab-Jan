import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/themes.dart';
import 'settings_cubit.dart';
import 'settings_state.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (blocContext, state) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.onSecondary,
                Theme.of(context).colorScheme.secondaryVariant,
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _appBar(),
            body: _params(state),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Create a new page'),
    );
  }

  Widget _params(state) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              const Text('theme'),
              IconButton(
                icon: const Icon(Icons.wb_sunny_rounded),
                onPressed: BlocProvider.of<SettingsCubit>(context).changeTheme,
              )
            ],
          ),
          Row(
            children: [
              const Text('Use biometrics to log in'),
              Switch(
                value: state.useBiometrics,
                onChanged: (value) {
                  setState(() {
                    BlocProvider.of<SettingsCubit>(context)
                        .changeBiometricsUsage();
                  });
                },
                activeTrackColor: Theme.of(context).colorScheme.onSecondary,
                activeColor: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
          Row(
            children: [
              const Text('add categories'),
              Switch(
                value: state.isCategoryPanelVisible,
                onChanged: (value) {
                  setState(() {
                    BlocProvider.of<SettingsCubit>(context)
                        .changeCategoryPanelVisibility();
                  });
                },
                activeTrackColor: Theme.of(context).colorScheme.onSecondary,
                activeColor: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
          Row(
            children: [
              const Text('Date-Time modification'),
              Switch(
                value: state.isCustomDateUsed,
                onChanged: (value) {
                  setState(() {
                    BlocProvider.of<SettingsCubit>(context)
                        .changeCustomDateUsage();
                  });
                },
                activeTrackColor: Theme.of(context).colorScheme.onSecondary,
                activeColor: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
          Row(
            children: [
              const Text('Bubble alignment'),
              Switch(
                value: state.isMessageSwitchOn,
                onChanged: (value) {
                  setState(() {
                    BlocProvider.of<SettingsCubit>(context)
                        .changeMessageAlignment();
                  });
                },
                activeTrackColor: Theme.of(context).colorScheme.onSecondary,
                activeColor: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
          Row(
            children: [
              const Text('Center date bubble'),
              Switch(
                value: state.isDateSwitchOn,
                onChanged: (value) {
                  setState(() {
                    BlocProvider.of<SettingsCubit>(context)
                        .changeDateAlignment();
                  });
                },
                activeTrackColor: Theme.of(context).colorScheme.onSecondary,
                activeColor: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
