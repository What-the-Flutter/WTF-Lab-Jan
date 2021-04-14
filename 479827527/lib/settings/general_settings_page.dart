import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../themes/cubit_theme.dart';
import 'cubit_general_settings_page.dart';
import 'states_general_settings_page.dart';

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  @override
  void initState() {
    BlocProvider.of<CubitGeneralSettings>(context).updateState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitGeneralSettings, StatesGeneralSettings>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'General',
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
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
        size: 25,
      ),
      title: Text(
        title,
      ),
      subtitle: Text(
        subtitle,
      ),
    );
  }

  void _showFontSizeDialog(StatesGeneralSettings state) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
          child: Container(
            height: 270,
            child: _dialogColumn(state),
          ),
        );
      },
    );
  }

  Column _dialogColumn(StatesGeneralSettings state) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Choose font size',
            ),
          ),
        ),
        Expanded(
          child: _dialogListView(state),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(
                Icons.clear,
                size: 35,
                color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  ListView _dialogListView(StatesGeneralSettings state) {
    return ListView(
      children: <ListTile>[
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
    );
  }

  ListView _listView(StatesGeneralSettings state) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              'Visuals',
              style: TextStyle(
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
            onTap: () => BlocProvider.of<CubitTheme>(context).changeTheme(),
          ),
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 17,
            ),
            child: _visualSettingsListTile(
              Icons.text_fields,
              'Font size',
              'Small / Default / Large',
            ),
          ),
          onTap: () => _showFontSizeDialog(state),
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 17,
            ),
            child: _visualSettingsListTile(
              Icons.replay_circle_filled,
              'Reset all preferences',
              'Reset all Visual Customizations',
            ),
          ),
          onTap: () {
            if (!BlocProvider.of<CubitTheme>(context).state.isLightTheme) {
              BlocProvider.of<CubitTheme>(context).changeTheme();
            }
            BlocProvider.of<CubitGeneralSettings>(context)
                .resetAllPreferences();
            BlocProvider.of<CubitTheme>(context).setTextTheme(2);
          },
        ),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
            ),
            child: Text(
              'Chat Interface',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          subtitle: ListTile(
            leading: Icon(
              Icons.date_range_outlined,
              color: Theme.of(context).iconTheme.color,
              size: 25,
            ),
            title: Text(
              'Date-Time Modification',
            ),
            subtitle: Text(
              'Allows manual date & time for an entry',
            ),
            trailing: Switch(
              activeColor:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor,
              value: state.isDateTimeModification,
              onChanged: (value) {
                BlocProvider.of<CubitGeneralSettings>(context)
                    .changeDateTimeModification();
              },
            ),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.only(
            left: 30.0,
          ),
          leading: Icon(
            Icons.notes,
            color: Theme.of(context).iconTheme.color,
            size: 25,
          ),
          title: Text(
            'Bubble Alignment',
          ),
          subtitle: Text(
            'Force right-to-left bubble alignment',
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(
              right: 32.0,
            ),
            child: Switch(
              activeColor:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor,
              value: state.isBubbleAlignment,
              onChanged: (value) {
                BlocProvider.of<CubitGeneralSettings>(context)
                    .changeBubbleAlignment();
              },
            ),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.only(
            left: 30.0,
          ),
          leading: Icon(
            Icons.calendar_view_day,
            color: Theme.of(context).iconTheme.color,
            size: 25,
          ),
          title: Text(
            'Center Date Bubble',
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: Switch(
              activeColor:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor,
              value: state.isCenterDateBubble,
              onChanged: (value) {
                BlocProvider.of<CubitGeneralSettings>(context)
                    .changeCenterDateBubble();
              },
            ),
          ),
        ),
      ],
    );
  }
}
