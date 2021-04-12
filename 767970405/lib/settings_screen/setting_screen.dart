import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_journal/settings_screen/visual_setting_cubit.dart';

import '../data/constants/constants.dart';
import '../data/custom_icon/my_flutter_app_icons.dart';
import '../data/theme/custom_theme.dart' as my;
import '../main.dart';
import '../widgets/custom_list_tile.dart';
import 'chat_interface_setting_cubit.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = 'SettingsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
          child: Text('Settings'),
        ),
      ),
      body: _settingsList(context),
    );
  }

  Widget _settingsList(BuildContext context) {
    final listTileTheme = my.ListTileTheme(
      titleStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: context.read<VisualSettingCubit>().state.titleFontSize,
      ),
      contentStyle: TextStyle(
        fontSize: context.read<VisualSettingCubit>().state.bodyFontSize,
      ),
    );
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        padding,
        CustomListTile(
          leadingIcon: Icons.nature_people,
          title: 'General',
          subtitle: 'Themes & Interface settings',
          onTap: () {
            Navigator.pushNamed(
              context,
              GeneralOption.routeName,
            );
          },
          theme: listTileTheme.copyWith(
            leadingIconColor: Colors.green,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: context.read<VisualSettingCubit>().state.appAccentColor,
          ),
        ),
        padding,
        CustomListTile(
          leadingIcon: Icons.cloud,
          title: 'Backup & Sync',
          subtitle: 'Local & Drive backup & sync',
          onTap: () {
            //TODO
          },
          theme: listTileTheme.copyWith(
            leadingIconColor: Colors.blue,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: context.read<VisualSettingCubit>().state.appAccentColor,
          ),
        ),
        padding,
        CustomListTile(
          leadingIcon: Icons.archive,
          title: 'Exports',
          subtitle: 'Textual backup of all your entries',
          onTap: () {
            //TODO
          },
          theme: listTileTheme.copyWith(
            leadingIconColor: Colors.orangeAccent,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: context.read<VisualSettingCubit>().state.appAccentColor,
          ),
        ),
        padding,
        CustomListTile(
          leadingIcon: Icons.lock,
          title: 'Security',
          subtitle: 'Pin & Fingerprint protection',
          onTap: () {
            Navigator.pushNamed(
              context,
              SecurityOption.routeName,
            );
          },
          theme: listTileTheme.copyWith(
            leadingIconColor: Colors.grey,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: context.read<VisualSettingCubit>().state.appAccentColor,
          ),
        ),
        padding,
        CustomListTile(
          leadingIcon: Icons.offline_bolt_outlined,
          title: 'Quick Setup',
          subtitle: 'Create pre-defined pages quickly',
          onTap: () {
            //TODO
          },
          theme: listTileTheme.copyWith(
            leadingIconColor: Colors.yellow,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: context.read<VisualSettingCubit>().state.appAccentColor,
          ),
        ),
        padding,
        CustomListTile(
          leadingIcon: Icons.help_outline,
          title: 'Help',
          subtitle: 'Basic usage guide',
          onTap: () {
            Navigator.pop(context);
          },
          theme: listTileTheme.copyWith(
            leadingIconColor: Colors.blue,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: context.read<VisualSettingCubit>().state.appAccentColor,
          ),
        ),
        padding,
        CustomListTile(
          leadingIcon: Icons.info_outline,
          title: 'App Info',
          onTap: () {
            Navigator.pop(context);
          },
          theme: listTileTheme.copyWith(
            leadingIconColor: Colors.red,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: context.read<VisualSettingCubit>().state.appAccentColor,
          ),
        ),
        padding,
      ],
    );
  }

  Widget get padding => Padding(
        child: Divider(),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
      );
}

class GeneralOption extends StatelessWidget {
  static const routeName = 'GeneralOptions';

  @override
  Widget build(BuildContext context) {
    final state = context.read<VisualSettingCubit>().state;
    final listTileTheme = my.ListTileTheme(
      titleStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: state.titleFontSize,
      ),
      contentStyle: TextStyle(
        fontSize: state.bodyFontSize,
      ),
    );
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: state.appAccentColor,
        textTheme: TextTheme(
          subtitle1: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: state.titleFontSize,
            color: state.titleColor,
          ),
          bodyText2: TextStyle(
            fontSize: state.bodyFontSize,
            color: state.bodyColor,
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('General'),
          actions: <Widget>[],
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Visual',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            CustomListTile(
              title: 'Theme',
              leadingIcon: Icons.invert_colors,
              subtitle: 'Light / Dark',
              onTap: () {
                final cubit = context.read<VisualSettingCubit>();
                cubit.toggleTheme();
                cubit.saveVisualSettings(
                  'theme',
                  cubit.state.appBrightness.index,
                );
              },
              theme: listTileTheme.copyWith(
                leadingIconColor: Colors.purpleAccent,
              ),
            ),
            padding,
            CustomListTile(
              leadingIcon: Icons.circle,
              title: 'Accent Color',
              subtitle: 'Cyan, Mint, Lime and more',
              theme: listTileTheme.copyWith(
                leadingIconColor: Theme.of(context).accentColor,
              ),
              onTap: () async {
                final cubit = context.read<VisualSettingCubit>();
                var type = await _showAccentColorDialog(context);
                cubit.changeAccentColor(type);
                cubit.saveVisualSettings('accentColor', type.index);
              },
            ),
            padding,
            CustomListTile(
              leadingIcon: Icons.title,
              title: 'Typeface',
              subtitle: 'Roboto / RobotoMono',
              theme: listTileTheme.copyWith(
                leadingIconColor: Colors.orangeAccent,
              ),
              onTap: () async {
                final cubit = context.read<VisualSettingCubit>();
                var type = await _showFontFamilyDialog(context);
                cubit.changeFontFamily(type);
                cubit.saveVisualSettings('typeFace', type.index);
              },
            ),
            padding,
            CustomListTile(
              leadingIcon: Icons.text_fields,
              title: 'Font size',
              subtitle: 'Small / Default / Large',
              onTap: () async {
                final cubit = context.read<VisualSettingCubit>();
                var type = await _showFontSizeDialog(context);
                cubit.changeFontSize(type);
                cubit.saveVisualSettings('fontSize', type.index);
              },
              theme: listTileTheme.copyWith(
                leadingIconColor: Colors.indigo,
              ),
            ),
            padding,
            CustomListTile(
              leadingIcon: Icons.settings_backup_restore,
              title: 'Reset all Preference',
              subtitle: 'Reset all visual Customizations',
              onTap: context.read<VisualSettingCubit>().resetVisualSetting,
              theme: listTileTheme.copyWith(
                leadingIconColor: Colors.orangeAccent,
              ),
            ),
            padding,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Chat Interface',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            BlocBuilder<ChatInterfaceSettingCubit, ChatInterfaceSettingState>(
              builder: (context, state) => SwitchListTile(
                secondary: Icon(
                  Icons.date_range,
                  color: Colors.green,
                ),
                title: Text('Date-Time Modification'),
                subtitle: Text('Allows manual date & time for an entry'),
                value: state.isDateTimeModification,
                onChanged: (value) {
                  final cubit = context.read<ChatInterfaceSettingCubit>();
                  cubit.changeDateTimeModification(value);
                  cubit.saveChatInterfaceSettings('timeModification', value);
                },
              ),
            ),
            padding,
            BlocBuilder<ChatInterfaceSettingCubit, ChatInterfaceSettingState>(
              builder: (context, state) => SwitchListTile(
                secondary: Icon(
                  Icons.format_align_right,
                  color: Colors.lightBlue,
                ),
                title: Text('Bubble Alignment'),
                subtitle: Text('Force right-to-left bubble alignment'),
                value: state.isLeftBubbleAlign,
                onChanged:
                    (value) {
                  final cubit = context.read<ChatInterfaceSettingCubit>();
                  cubit.changeBubbleAlign(value);
                  cubit.saveChatInterfaceSettings('bubbleAlign', value);
                },
              ),
            ),
            padding,
            BlocBuilder<ChatInterfaceSettingCubit, ChatInterfaceSettingState>(
              builder: (context, state) => SwitchListTile(
                secondary: Icon(
                  Icons.wb_iridescent,
                  color: Colors.orange,
                ),
                title: Text('Center Date Bubble'),
                value: state.isCenterDateBubble,
                onChanged:(value) {
                  final cubit = context.read<ChatInterfaceSettingCubit>();
                  cubit.changeCenterDateBubble(value);
                  cubit.saveChatInterfaceSettings('dateBubble', value);
                },
              ),
            ),
            padding,
            SwitchListTile(
              secondary: Icon(
                Icons.save,
                color: Colors.blue,
              ),
              title: Text('Save Images Locally'),
              subtitle: Text('Save a copy of of image in-app locally'),
              value: false,
              onChanged: (value) => true,
            ),
            padding,
            CustomListTile(
              leadingIcon: Icons.wallpaper,
              title: 'Background Image',
              subtitle: 'Chat background image',
              onTap: () => Navigator.pushNamed(
                context,
                BackgroundImageScreen.routeName,
              ),
              theme: listTileTheme.copyWith(
                leadingIconColor: Colors.deepOrange,
              ),
            ),
            padding,
            SwitchListTile(
              secondary: Icon(
                Icons.mms,
                color: Colors.pinkAccent,
              ),
              title: Text('Images Date-time'),
              subtitle: Text('Fetch date & time from when the image was taken'),
              value: false,
              onChanged: (value) => true,
            ),
            padding,
            SwitchListTile(
              secondary: Icon(
                MyFlutterApp.smart_toy_24px,
                color: Colors.deepOrangeAccent,
              ),
              title: Text('Hide Questionnaire Bot'),
              value: false,
              onChanged: (value) => true,
            ),
            padding,
            CustomListTile(
              leadingIcon: Icons.refresh,
              title: 'Reset all pinned pages',
              subtitle: 'Unpin all pages',
              theme: listTileTheme.copyWith(
                leadingIconColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get padding => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(),
      );

  Future<TypeFontSize> _showFontSizeDialog(BuildContext context) async {
    return await showDialog<TypeFontSize>(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                'Font Size',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            ListTile(
              title: Text(
                'Small',
              ),
              onTap: () => Navigator.pop(context, TypeFontSize.small),
            ),
            ListTile(
              title: Text(
                'Default',
              ),
              onTap: () => Navigator.pop(context, TypeFontSize.def),
            ),
            ListTile(
              title: Text(
                'Large',
              ),
              onTap: () => Navigator.pop(context, TypeFontSize.large),
            ),
          ],
        ),
      ),
    );
  }

  Future<TypeFontFamily> _showFontFamilyDialog(BuildContext context) async {
    return await showDialog<TypeFontFamily>(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                'Font family',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            ListTile(
              title: Text(
                'Roboto',
              ),
              onTap: () => Navigator.pop(context, TypeFontFamily.roboto),
            ),
            ListTile(
              title: Text(
                'RobotoMono',
              ),
              onTap: () => Navigator.pop(context, TypeFontFamily.robotoMono),
            ),
          ],
        ),
      ),
    );
  }

  Future<TypeAccentColor> _showAccentColorDialog(BuildContext context) async {
    return await showDialog<TypeAccentColor>(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          title: Text(
            'Accent Color',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * (2 / 5),
          width: MediaQuery.of(context).size.height * (4 / 5),
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.circle,
                  color: Colors.amberAccent,
                ),
                title: Text(
                  'Gold',
                ),
                onTap: () => Navigator.pop(context, TypeAccentColor.gold),
              ),
              ListTile(
                leading: Icon(
                  Icons.circle,
                  color: Colors.cyan,
                ),
                title: Text(
                  'Cyan',
                ),
                onTap: () => Navigator.pop(context, TypeAccentColor.cyan),
              ),
              ListTile(
                leading: Icon(
                  Icons.circle,
                  color: Colors.greenAccent,
                ),
                title: Text(
                  'Mint',
                ),
                onTap: () => Navigator.pop(context, TypeAccentColor.mint),
              ),
              ListTile(
                leading: Icon(
                  Icons.circle,
                  color: Colors.lime,
                ),
                title: Text(
                  'Lime',
                ),
                onTap: () => Navigator.pop(context, TypeAccentColor.lime),
              ),
              ListTile(
                leading: Icon(
                  Icons.circle,
                  color: Colors.pink,
                ),
                title: Text(
                  'Pink',
                ),
                onTap: () => Navigator.pop(context, TypeAccentColor.pink),
              ),
              ListTile(
                leading: Icon(
                  Icons.circle,
                  color: Colors.green,
                ),
                title: Text(
                  'Green',
                ),
                onTap: () => Navigator.pop(context, TypeAccentColor.green),
              ),
              ListTile(
                leading: Icon(
                  Icons.circle,
                  color: Colors.orange,
                ),
                title: Text(
                  'Orange',
                ),
                onTap: () => Navigator.pop(context, TypeAccentColor.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecurityOption extends StatelessWidget {
  static const routeName = 'SecurityOptions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
          child: Text('Security'),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          BlocBuilder<ChatInterfaceSettingCubit, ChatInterfaceSettingState>(
            builder: (context, state) => SwitchListTile(
              secondary: Icon(
                Icons.mms,
                color: Colors.blue,
              ),
              title: Text('Fingerprint'),
              subtitle: Text('Enable Fingerprint unlock'),
              value: state.isAuthentication,
              onChanged: context
                  .read<ChatInterfaceSettingCubit>()
                  .changeAuthentication,
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundImageScreen extends StatelessWidget {
  static const routeName = 'BackgroundImage';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('BackgroundImage'),
        centerTitle: true,
      ),
      body: BlocBuilder<ChatInterfaceSettingCubit, ChatInterfaceSettingState>(
        builder: (context, state) => Container(
          alignment: Alignment.center,
          child: state.pathBackgroundImage.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * (2 / 5),
                    ),
                    Text('Click the button below to set the'),
                    Text('Background Image'),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: OutlinedButton(
                        onPressed:() async {
                          final cubit = context.read<ChatInterfaceSettingCubit>();
                          await cubit.pickImage();
                          cubit.saveBackgroundImage(cubit.state.pathBackgroundImage);
                        },
                        child: Text('Pick an Image'),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                      child: SizedBox(
                        width: size.width * (4 / 5),
                        height: size.height * (3 / 5),
                        child: Image.file(
                          File(state.pathBackgroundImage),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Unset Image'),
                      onTap: () {
                        final cubit = context.read<ChatInterfaceSettingCubit>();
                        cubit.unsetImage();
                        cubit.saveBackgroundImage('');
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: ListTile(
                        leading: Icon(Icons.wallpaper),
                        title: Text('Pick a new Image'),
                        onTap: () async {
                          final cubit = context.read<ChatInterfaceSettingCubit>();
                          await cubit.pickImage();
                          cubit.saveBackgroundImage(cubit.state.pathBackgroundImage);
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
