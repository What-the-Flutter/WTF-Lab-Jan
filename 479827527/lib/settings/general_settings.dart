import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit_general_settings.dart';
import 'states_general_settings.dart';

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  final CubitGeneralSettings _cubit =
      CubitGeneralSettings(StatesGeneralSettings());

  @override
  void initState() {
    _cubit.initSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'General',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          body: _listView(state),
        );
      },
    );
  }

  ListTile _visualSettingsListTile(
      IconData icon, String title, String subtitle) {
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
        size: 25,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }

  ListView _listView(StatesGeneralSettings state) {
    return ListView(
      children: <Widget>[
        ListTile(
          dense: true,
          title: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              'Visuals',
              style: TextStyle(
                fontSize: 17,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          subtitle: GestureDetector(
            child: _visualSettingsListTile(
              Icons.invert_colors,
              'Theme',
              'Light / Dark',
            ),
            onTap: () {
              //TODO
            },
          ),
        ),
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(
              left: 17,
            ),
            child: _visualSettingsListTile(
              Icons.text_fields,
              'Font size',
              'Small / Default / Large',
            ),
          ),
          onTap: () {
            //TODO
          },
        ),
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(
              left: 17,
            ),
            child: _visualSettingsListTile(
              Icons.replay_circle_filled,
              'Reset all preferences',
              'Reset all Visual Customizations',
            ),
          ),
          onTap: () {
            //TODO
          },
        ),
        ListTile(
          dense: true,
          title: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
            ),
            child: Text(
              'Chat Interface',
              style: TextStyle(
                fontSize: 17,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          subtitle: ListTile(
            dense: true,
            leading: Icon(
              Icons.date_range_outlined,
              color: Theme.of(context).iconTheme.color,
              size: 25,
            ),
            title: Text(
              'Date-Time Modification',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              'Allows manual date & time for an entry',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: Switch(
              value: state.isDateTimeModification,
              onChanged: (value) {
                _cubit.changeDateTimeModification();
              },
            ),
          ),
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.only(left: 30.0),
          leading: Icon(
            Icons.notes,
            color: Theme.of(context).iconTheme.color,
            size: 25,
          ),
          title: Text(
            'Bubble Alignment',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            'Force right-to-left bubble alignment',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: Switch(
              value: state.isBubbleAlignment,
              onChanged: (value) {
                _cubit.changeBubbleAlignment();
              },
            ),
          ),
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.only(left: 30.0),
          leading: Icon(
            Icons.calendar_view_day,
            color: Theme.of(context).iconTheme.color,
            size: 25,
          ),
          title: Text(
            'Center Date Bubble',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: Switch(
              value: state.isCenterDateBubble,
              onChanged: (value) {
                _cubit.changeCenterDateBubble();
              },
            ),
          ),
        ),
      ],
    );
  }
}
