import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/cubit_theme.dart';
import 'cubit_general_settings.dart';
import 'states_general_settings.dart';

class GeneralSettingsPage extends StatefulWidget {
  @override
  _GeneralSettingsPageState createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CubitGeneralSettings>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitGeneralSettings, StatesGeneralSettings>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar,
          body: _bodyGeneralSettings(state),
        );
      },
    );
  }

  ListView _bodyGeneralSettings(StatesGeneralSettings state) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.invert_colors),
          title: const Text('Theme'),
          subtitle: const Text('Light/Dark'),
          onTap: () => BlocProvider.of<CubitTheme>(context).changeTheme(),
        ),
        ListTile(
          leading: const Icon(Icons.format_size),
          title: const Text('Front Size'),
          subtitle: const Text('Small / Default / Large'),
          onTap: _showDialog,
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today_outlined),
          title: const Text('Date-Time Modification'),
          subtitle: const Text('Allows manual date & time for an entry'),
          trailing: Switch(
            value: state.isDateTimeModification,
            onChanged: (value) {
              BlocProvider.of<CubitGeneralSettings>(context)
                  .changeDateTimeModification();
            },
          ),
        ),
        ListTile(
          leading: state.isBubbleAlignment
              ? const Icon(Icons.format_align_right)
              : const Icon(Icons.format_align_left),
          title: const Text('Bubble Alignment'),
          subtitle: const Text('Force right-to-left bubble alignment'),
          trailing: Switch(
            value: state.isBubbleAlignment,
            onChanged: (value) {
              BlocProvider.of<CubitGeneralSettings>(context)
                  .changeBubbleAlignment();
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.format_align_center),
          title: const Text('Center Date Bubble'),
          trailing: Switch(
            value: state.isCenterDateBubble,
            onChanged: (value) {
              BlocProvider.of<CubitGeneralSettings>(context)
                  .changeCenterDateBubble();
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.replay),
          title: const Text('Reset All Preferences'),
          subtitle: const Text('Reset all Visual Customization'),
          onTap: () {
            BlocProvider.of<CubitGeneralSettings>(context)
                .resetAllPreferences();
            if (!BlocProvider.of<CubitTheme>(context).state.isLightTheme!) {
              BlocProvider.of<CubitTheme>(context).changeTheme();
            }
            BlocProvider.of<CubitTheme>(context).setTextTheme(2);
          },
        ),
      ],
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose the page'),
          content: _dialogListView(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),  
            ),
          ],
        );
      },
    );
  }

  Container _dialogListView() {
    return Container(
      height: 250,
      width: 50,
      child: ListView(
        children: [
          ListTile(
            title: const Text(
              'Small',
            ),
            onTap: () {
              BlocProvider.of<CubitTheme>(context).setTextTheme(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              'Default',
            ),
            onTap: () {
              BlocProvider.of<CubitTheme>(context).setTextTheme(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              'Large',
            ),
            onTap: () {
              BlocProvider.of<CubitTheme>(context).setTextTheme(3);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: const Text('General'),
    );
  }
}
