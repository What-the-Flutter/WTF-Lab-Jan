import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/theme_cubit.dart';

import 'background_image_setting/background_image_setting.dart';
import 'general_settings_cubit.dart';

class GeneralSettingsPage extends StatefulWidget {
  @override
  _GeneralSettingsPageState createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneralSettingsCubit, GeneralSettingsStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('General'),
          ),
          body: _bodyListView(state),
        );
      },
    );
  }

  @override
  void initState() {
    BlocProvider.of<GeneralSettingsCubit>(context).initStates();
    super.initState();
  }

  ListView _bodyListView(GeneralSettingsStates state) {
    return ListView(
      padding: EdgeInsets.only(top: 10),
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            leading: Icon(Icons.invert_colors),
            title: Text('Theme'),
            subtitle: Text('Light / Dark'),
            onTap: () => BlocProvider.of<ThemeCubit>(context).changeTheme(),
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('Font Size'),
            subtitle: Text('Small / Default / Large'),
            onTap: _showDialogWindow,
          ),
          ListTile(
            leading: Icon(Icons.replay),
            title: Text('Reset All Preferences'),
            subtitle: Text('Reset all Visual Customization'),
            onTap: () {
              BlocProvider.of<GeneralSettingsCubit>(context)
                  .resetAllPreferences();
              BlocProvider.of<ThemeCubit>(context).setLightTheme();
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today_outlined),
            trailing: Switch(
              value: state.isDateTimeModification,
              onChanged: BlocProvider.of<GeneralSettingsCubit>(context)
                  .setDateTimeModificationState,
            ),
            title: Text('Date-Time Modification'),
            subtitle: Text('Allows manual date & time for an entry'),
          ),
          ListTile(
            leading: Icon(Icons.format_align_right),
            trailing: Switch(
              value: state.isBubbleAlignment,
              onChanged: BlocProvider.of<GeneralSettingsCubit>(context)
                  .setBubbleAlignmentState,
            ),
            title: Text('Bubble Alignment'),
            subtitle: Text('Force right-to-left bubble alignment'),
          ),
          ListTile(
            leading: Icon(Icons.vertical_align_center),
            trailing: Switch(
              value: state.isCenterDateBubble,
              onChanged: BlocProvider.of<GeneralSettingsCubit>(context)
                  .setCenterDateBubbleState,
            ),
            title: Text('Center Date Bubble'),
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Background Image'),
            subtitle: Text('Chat background image'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BackgroundImageSetting(),
              ),
            ),
          ),
        ],
      ).toList(),
    );
  }

  void _showDialogWindow() {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<GeneralSettingsCubit, GeneralSettingsStates>(
          builder: (context, state) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              elevation: 16,
              child: Container(
                width: 150,
                height: 250,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Font Size',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    _listTile('Small', 0),
                    _listTile('Default', 1),
                    _listTile('Large', 2),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Ok'),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  ListTile _listTile(String size, int index) {
    return ListTile(
      title: Text(size),
      onTap: () {
        BlocProvider.of<ThemeCubit>(context).changeTextTheme(index);
        Navigator.pop(context);
      },
    );
  }
}
