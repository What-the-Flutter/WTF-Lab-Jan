import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            title: const Align(
              child: Text('Settings'),
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
              child: _settingsScreenContainer(),
            ),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: _categorySettingsListTile(state),
        ),
      ],
    );
  }

  Widget _settingsScreenContainer() {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        margin: const EdgeInsets.fromLTRB(25, 50, 25, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Connect your Google account to automatically sync your entries to your drive',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 18,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Link to your drive',
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  ListTile _categorySettingsListTile(SettingsState state) {
    return ListTile(
      leading: const Icon(Icons.workspaces_filled),
      title: const Text('Add category'),
      trailing: Switch.adaptive(
        value: state.isCategoryListOpen,
        onChanged: (value) =>
            BlocProvider.of<SettingsCubit>(context)
                .changeAbilityChooseCategory(),
      ),
      onTap: () {},
    );
  }
}
