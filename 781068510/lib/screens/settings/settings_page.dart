import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/settings/settings_cubit.dart';
import '../../cubit/settings/settings_state.dart';
import 'general_settings/general_settings_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const double iconSize = 25.0;
  late var state;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, GeneralSettingsStates>(
      builder: (context, state) {
        this.state = state;
        return Scaffold(
          appBar: _appBar,
          body: _listView,
        );
      },
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: const Text(
        'Settings',
      ),
    );
  }

  ListView get _listView {
    return ListView(
      padding: const EdgeInsets.only(top: 10),
      children: <Widget>[
        GestureDetector(
          child: ListTile(
            leading: const Icon(Icons.color_lens, size: iconSize),
            title: Text(
              'General',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Themes & Interface settings',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GeneralSettings(),
              ),
            );
          },
        ),
        GestureDetector(
          child: ListTile(
            leading: const Icon(Icons.cloud, size: iconSize),
            title: Text(
              'Backup & Sync',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Local & Drive backup & sync',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {
            //TODO
          },
        ),
        GestureDetector(
          child: ListTile(
            leading: const Icon(Icons.archive, size: iconSize),
            title: Text(
              'Exports',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Textual backup of all your entries',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {
            //TODO
          },
        ),
        GestureDetector(
          child: ListTile(
            leading: const Icon(Icons.lock, size: iconSize),
            title: Text(
              'Security',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Pin & Fingerprint protection',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {
            //TODO
          },
        ),
        GestureDetector(
          child: ListTile(
            leading: const Icon(Icons.quickreply, size: iconSize),
            title: Text(
              'Quick Setup',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Create pre-defined pages quickly',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {},
        ),
        GestureDetector(
          child: ListTile(
            leading: const Icon(Icons.help, size: iconSize),
            title: Text(
              'Help',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Basic usage guide',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {},
        ),
        GestureDetector(
          child: ListTile(
            leading: const Icon(Icons.info, size: iconSize),
            title: Text(
              'App info',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Feedback & Specifications',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
