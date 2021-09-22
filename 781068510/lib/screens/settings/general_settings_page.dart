import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/cubit/settings/settings_cubit.dart';
import 'package:notes/cubit/settings/settings_state.dart';
import 'package:notes/cubit/themes/theme_cubit.dart';

const double iconSize = 25.0;

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  @override
  void initState() {
    BlocProvider.of<SettingsCubit>(context).getState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, GeneralSettingsStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar,
          body: _listView(state),
        );
      },
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: const Text(
        'General',
      ),
    );
  }

  Widget _listView(GeneralSettingsStates state) {
    return ListView(
      padding: const EdgeInsets.only(left: 10, right: 10),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(6),
          child: const Text(
            'Visuals',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          child: ListTile(
            leading: BlocProvider.of<ThemeCubit>(context).state.isDarkMode! ?
            const Icon(Icons.dark_mode, size: iconSize) :
            const Icon(Icons.light_mode, size: iconSize),
            title: const Text('Theme'),
            subtitle: const Text('Light/Dark'),
          ),
          onTap: () => BlocProvider.of<ThemeCubit>(context).changeTheme(),
        ),
        GestureDetector(
          child: const ListTile(
            leading: Icon(Icons.star_border_purple500, size: iconSize),
            title: Text('AccentColor'),
            subtitle: Text('Purple, Cyan and more'),
          ),
          onTap: () {
            //TODO
          },
        ),
        GestureDetector(
          child: const ListTile(
            leading: Icon(Icons.font_download, size: iconSize),
            title: Text('Typeface'),
            subtitle: Text('OpenSans/RobotoMono'),
          ),
          onTap: () {
            //TODO
          },
        ),
        GestureDetector(
          child: const ListTile(
            leading: Icon(Icons.format_size, size: iconSize),
            title: Text('Font Size'),
            subtitle: Text('Small/Default/Large'),
          ),
          onTap: () {
            //TODO
          },
        ),
        GestureDetector(
          child: const ListTile(
            leading: Icon(Icons.settings_backup_restore, size: iconSize),
            title: Text('Reset All Preferences'),
            subtitle: Text('Reset all Visual Customizations'),
          ),
          onTap: () {
            BlocProvider.of<SettingsCubit>(context).resetAllPreferences();
          },
        ),
        Container(
          padding: const EdgeInsets.all(6),
          child: const Text(
            'Chat Interface',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          child: ListTile(
            leading: const Icon(Icons.date_range, size: iconSize),
            title: const Text('Date-Time Modification'),
            subtitle: const Text('Allow manual date & time for an entry'),
            trailing: Switch(
              onChanged: (value) {
                BlocProvider.of<SettingsCubit>(context)
                    .changeDateTimeModification();
              },
              value: state.isDateTimeModification,
            ),
          ),
          onTap: () => BlocProvider.of<SettingsCubit>(context)
              .changeDateTimeModification(),
        ),
        GestureDetector(
          child: ListTile(
            leading: state.isBubbleAlignment
                ? const Icon(Icons.format_align_left_outlined, size: iconSize)
                : const Icon(Icons.format_align_right_outlined, size: iconSize),
            title: const Text('Bubble Alignment'),
            subtitle: const Text('Force right-to-left bubble alignment'),
            trailing: Switch(
              onChanged: (value) {
                BlocProvider.of<SettingsCubit>(context).changeBubbleAlignment();
              },
              value: state.isBubbleAlignment,
            ),
          ),
          onTap: () =>
              BlocProvider.of<SettingsCubit>(context).changeBubbleAlignment(),
        ),
        GestureDetector(
          child: ListTile(
            leading: state.isCenterDateBubble
                ? const Icon(Icons.filter_center_focus_outlined, size: iconSize)
                : const Icon(Icons.center_focus_strong_outlined,
                    size: iconSize),
            title: const Text('Center Date Bubble'),
            trailing: Switch(
              onChanged: (value) {
                BlocProvider.of<SettingsCubit>(context)
                    .changeCenterDateBubble();
              },
              value: state.isCenterDateBubble,
            ),
          ),
          onTap: () =>
              BlocProvider.of<SettingsCubit>(context).changeCenterDateBubble(),
        ),
      ],
    );
  }
}
