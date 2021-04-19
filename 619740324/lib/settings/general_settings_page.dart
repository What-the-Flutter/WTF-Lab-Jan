import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/cubit_theme.dart';
import 'cubit_general_settings.dart';
import 'states_general_settings.dart';

class GeneralSettingsPage extends StatefulWidget {
  @override
  _GeneralSettingsPageState createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  final CubitGeneralSettings _cubitGeneralSettings =
      CubitGeneralSettings(StatesGeneralSettings());

  @override
  void initState() {
    _cubitGeneralSettings.updateState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitGeneralSettings, StatesGeneralSettings>(
      cubit: _cubitGeneralSettings,
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
          leading: Icon(Icons.invert_colors),
          title: Text('Theme'),
          subtitle: Text('Light/Dark'),
          onTap: () => BlocProvider.of<CubitTheme>(context).changeTheme(),
        ),
        ListTile(
          leading: Icon(Icons.format_size),
          title: Text('Front Size'),
          subtitle: Text('Small / Default / Large'),
          onTap: _showDialog,
        ),
        ListTile(
          leading: Icon(Icons.calendar_today_outlined),
          title: Text('Date-Time Modification'),
          subtitle: Text('Allows manual date & time for an entry'),
          trailing: Switch(
            value: state.isDateTimeModification,
            onChanged: (value) {
              _cubitGeneralSettings.changeDateTimeModification();
            },
          ),
        ),
        ListTile(
          leading: state.isBubbleAlignment
              ? Icon(Icons.format_align_right)
              : Icon(Icons.format_align_left),
          title: Text('Bubble Alignment'),
          subtitle: Text('Force right-to-left bubble alignment'),
          trailing: Switch(
            value: state.isBubbleAlignment,
            onChanged: (value) {
              _cubitGeneralSettings.changeBubbleAlignment();
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.format_align_center),
          title: Text('Center Date Bubble'),
          trailing: Switch(
            value: state.isCenterDateBubble,
            onChanged: (value) {
              _cubitGeneralSettings.changeCenterDateBubble();
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.replay),
          title: Text('Reset All Preferences'),
          subtitle: Text('Reset all Visual Customization'),
          onTap: () {
            if (state.isBubbleAlignment) {
              _cubitGeneralSettings.changeBubbleAlignment();
            }
            if (state.isDateTimeModification) {
              _cubitGeneralSettings.changeDateTimeModification();
            }
            if (state.isCenterDateBubble) {
              _cubitGeneralSettings.changeCenterDateBubble();
            }
            if (!BlocProvider.of<CubitTheme>(context).state.isLightTheme) {
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
          title: Text('Choose the page'),
          content: _dialogListView(),
          actions: [
            FlatButton(
                onPressed: () => Navigator.pop(context), child: Text('OK')),
          ],
        );
      },
    );
  }

  Container _dialogListView() {
    return Container(
      height: 150,
      child: ListView(
        children: [
          ListTile(
            title: Text(
              'Small',
            ),
            onTap: () {
              BlocProvider.of<CubitTheme>(context).setTextTheme(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Default',
            ),
            onTap: () {
              BlocProvider.of<CubitTheme>(context).setTextTheme(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
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
      title: Text('General'),
    );
  }
}
