import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/themes.dart';
import '../background_image/background_image_screen.dart';
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

  Widget _params(SettingsState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          _topParams(state),
          _switchParams(state),
          _bottomParams(state),
        ],
      ),
    );
  }

  Widget _topParams(SettingsState state) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Theme',
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
            IconButton(
              icon: Icon(Icons.wb_sunny_rounded,
                  color: Theme.of(context).colorScheme.background),
              onPressed: BlocProvider.of<SettingsCubit>(context).changeTheme,
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: GestureDetector(
            onTap: () => _fontSizeChoose(state),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Font size',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.background),
                  ),
                  Text(
                    'Small/Medium/Large',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.background),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BackgroundImagePage(),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Background image',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.background),
                  ),
                  Text(
                    'Chat background image',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.background),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _switchParams(SettingsState state) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Use biometrics to log in',
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
            Switch(
              value: state.useBiometrics,
              onChanged: (value) {
                BlocProvider.of<SettingsCubit>(context).changeBiometricsUsage();
              },
              activeTrackColor: Theme.of(context).colorScheme.onSecondary,
              activeColor: Theme.of(context).colorScheme.secondaryVariant,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'add categories',
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
            Switch(
              value: state.isCategoryPanelVisible,
              onChanged: (value) {
                BlocProvider.of<SettingsCubit>(context)
                    .changeCategoryPanelVisibility();
              },
              activeTrackColor: Theme.of(context).colorScheme.onSecondary,
              activeColor: Theme.of(context).colorScheme.secondaryVariant,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Date-Time modification',
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
            Switch(
              value: state.isCustomDateUsed,
              onChanged: (value) {
                BlocProvider.of<SettingsCubit>(context).changeCustomDateUsage();
              },
              activeTrackColor: Theme.of(context).colorScheme.onSecondary,
              activeColor: Theme.of(context).colorScheme.secondaryVariant,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Bubble alignment',
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
            Switch(
              value: state.isMessageSwitchOn,
              onChanged: (value) {
                BlocProvider.of<SettingsCubit>(context)
                    .changeMessageAlignment();
              },
              activeTrackColor: Theme.of(context).colorScheme.onSecondary,
              activeColor: Theme.of(context).colorScheme.secondaryVariant,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Center date bubble',
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
            Switch(
              value: state.isDateSwitchOn,
              onChanged: (value) {
                BlocProvider.of<SettingsCubit>(context).changeDateAlignment();
              },
              activeTrackColor: Theme.of(context).colorScheme.onSecondary,
              activeColor: Theme.of(context).colorScheme.secondaryVariant,
            ),
          ],
        ),
      ],
    );
  }

  Widget _bottomParams(SettingsState state) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: GestureDetector(
            onTap: () =>
                BlocProvider.of<SettingsCubit>(context).resetSettings(),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Reset settings',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: GestureDetector(
            onTap: BlocProvider.of<SettingsCubit>(context).onShareData,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Share app',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _fontSizeChoose(SettingsState state) {
    var _chosenFontSize;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: 300,
                width: 300,
                child: ListView(
                  children: [
                    RadioListTile(
                      title: Text(
                        'Small',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background),
                      ),
                      value: state.smallFontSize,
                      groupValue: _chosenFontSize,
                      onChanged: (index) =>
                          setState(() => _chosenFontSize = index),
                    ),
                    RadioListTile(
                      title: Text(
                        'Medium',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background),
                      ),
                      value: state.mediumFontSize,
                      groupValue: _chosenFontSize,
                      onChanged: (index) =>
                          setState(() => _chosenFontSize = index),
                    ),
                    RadioListTile(
                      title: Text(
                        'Large',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background),
                      ),
                      value: state.largeFontSize,
                      groupValue: _chosenFontSize,
                      onChanged: (value) =>
                          setState(() => _chosenFontSize = value),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                BlocProvider.of<SettingsCubit>(context)
                    .changeFontSize(_chosenFontSize);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
