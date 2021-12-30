import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'settings_cubit.dart';
import 'settings_state.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreensState createState() => _SettingsScreensState();
}

class _SettingsScreensState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Align(
              child: Text(
                'Settings',
                style: TextStyle(fontSize: state.chosenFontSize),
              ),
              alignment: Alignment.center,
            ),
          ),
          body: _bodyStructure(state),
        );
      },
    );
  }

  Widget _bodyStructure(SettingsState state) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: _settingsScreenContainer(state),
            ),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            children: <Widget>[
              _addCategorySettings(state),
              _bubbleAlignmentSettings(state),
              _changeThemeSettings(state),
              _biometricAuthSettings(state),
              _changeFontSize(state),
              _resetAllSettings(state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingsScreenContainer(SettingsState state) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie_settings.json',
              width: 220,
              height: 220,
              fit: BoxFit.fill,
              repeat: false,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Link to your drive',
                style: TextStyle(
                  fontSize: state.chosenFontSize,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ListTile _addCategorySettings(SettingsState state) {
    return ListTile(
      leading: const Icon(Icons.workspaces_filled),
      title: Text(
        'Add category',
        style: TextStyle(fontSize: state.chosenFontSize),
      ),
      trailing: Switch.adaptive(
        value: state.isCategoryListOpen,
        onChanged: (value) =>
            BlocProvider.of<SettingsCubit>(context)
                .changeAbilityChooseCategory(),
      ),
      onTap: () {},
    );
  }

  ListTile _bubbleAlignmentSettings(SettingsState state) {
    return ListTile(
      leading: const Icon(Icons.text_snippet_outlined),
      title: Text(
        'Bubble Alignment',
        style: TextStyle(fontSize: state.chosenFontSize),
      ),
      trailing: Switch.adaptive(
        value: state.isRightBubbleAlignment,
        onChanged: (value) =>
            BlocProvider.of<SettingsCubit>(context).changeBubbleAlignment(),
      ),
      onTap: () {},
    );
  }

  ListTile _changeThemeSettings(SettingsState state) {
    return ListTile(
      leading: const Icon(Icons.wb_incandescent_outlined),
      title: Text(
        'Change theme',
        style: TextStyle(fontSize: state.chosenFontSize),
      ),
      trailing: Switch.adaptive(
        value: state.isLightTheme,
        onChanged: (value) =>
            BlocProvider.of<SettingsCubit>(context).changeTheme(),
      ),
      onTap: () {},
    );
  }

  ListTile _changeFontSize(SettingsState state) {
    return ListTile(
      leading: const Icon(Icons.text_fields),
      title: Text(
        'Font Size',
        style: TextStyle(fontSize: state.chosenFontSize),
      ),
      subtitle: Text(
        'Small / Default / Large',
        style: TextStyle(fontSize: state.chosenFontSize),
      ),
      onTap: () => _showReplyDialog(state),
    );
  }

  void _showReplyDialog(SettingsState state) {
    var dialog = AlertDialog(
      insetPadding: const EdgeInsets.all(50),
      title: Text(
        'Font Size',
        style: TextStyle(
          fontSize: state.chosenFontSize,
          color: Colors.black45,
        ),
      ),
      content: Container(
        height: 300,
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(5),
                children: <Widget>[
                  RadioListTile(
                    title: const Text('Small'),
                    value: state.smallFontSize,
                    groupValue: state.chosenFontSize,
                    onChanged: (value) =>
                        BlocProvider.of<SettingsCubit>(context)
                            .changeFontSize(value as double),
                  ),
                  RadioListTile(
                    title: const Text('Medium'),
                    value: state.mediumFontSize,
                    groupValue: state.chosenFontSize,
                    onChanged: (value) =>
                        BlocProvider.of<SettingsCubit>(context)
                            .changeFontSize(value as double),
                  ),
                  RadioListTile(
                    title: const Text('Large'),
                    value: state.largeFontSize,
                    groupValue: state.chosenFontSize,
                    onChanged: (value) =>
                        BlocProvider.of<SettingsCubit>(context)
                            .changeFontSize(value as double),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        _okButtonForReplyEvents(state),
      ],
    );
    showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
  }

  ElevatedButton _okButtonForReplyEvents(SettingsState state) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.indigoAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.0),
        ),
      ),
      child: Text(
        'Ok',
        style: TextStyle(
          color: Colors.black26,
          fontSize: state.chosenFontSize,
        ),
      ),
      onPressed: () {
        BlocProvider.of<SettingsCubit>(context).setFontSize();
        Navigator.of(context).pop();
      },
    );
  }

  ListTile _resetAllSettings(SettingsState state) {
    return ListTile(
      leading: const Icon(Icons.update),
      title: Text(
        'Reset All Settings',
        style: TextStyle(fontSize: state.chosenFontSize),
      ),
      subtitle: Text(
        'Reset all Visual Customizations',
        style: TextStyle(fontSize: state.chosenFontSize),
      ),
      onTap: () => BlocProvider.of<SettingsCubit>(context).resetAllSettings(),
    );
  }

  ListTile _biometricAuthSettings(SettingsState state) {
    return ListTile(
      leading: const Icon(Icons.fingerprint),
      title: Text(
        'Authentication with fingerprint',
        style: TextStyle(fontSize: state.chosenFontSize),
      ),
      trailing: Switch.adaptive(
        value: state.isBiometricAuth,
        onChanged: (value) =>
            BlocProvider.of<SettingsCubit>(context)
                .changeBiometricAuthAbility(),
      ),
      onTap: () {},
    );
  }
}

