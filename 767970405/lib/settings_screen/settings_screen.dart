import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_journal/data/constans/constans.dart';

import '../data/custom_icon/my_flutter_app_icons.dart';
import '../data/theme/custom_theme.dart';
import '../main.dart';
import 'general_options_cubit.dart';

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
    final listTileTheme = ListTileSettingsTheme(
      titleStyle: TextStyle(
        fontSize: context.read<GeneralOptionsCubit>().state.titleFontSize,
      ),
      contentStyle: TextStyle(
        fontSize: context.read<GeneralOptionsCubit>().state.bodyFontSize,
      ),
      leadingIconColor: Colors.blue,
    );
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        padding,
        SettingOptions(
          leadingIcon: Icons.nature_people,
          title: 'General',
          subtitle: 'Themes & Interface settings',
          onPressed: () {
            Navigator.pushNamed(
              context,
              GeneralOption.routeName,
            );
          },
          theme: listTileTheme,
        ),
        padding,
        SettingOptions(
          leadingIcon: Icons.cloud,
          title: 'Backup & Sync',
          subtitle: 'Local & Drive backup & sync',
          onPressed: () {
            //TODO
          },
          theme: listTileTheme,
        ),
        padding,
        SettingOptions(
          leadingIcon: Icons.archive,
          title: 'Exports',
          subtitle: 'Textual backup of all your entries',
          onPressed: () {
            //TODO
          },
          theme: listTileTheme,
        ),
        padding,
        SettingOptions(
          leadingIcon: Icons.lock,
          title: 'Security',
          subtitle: 'Pin & Fingerprint protection',
          onPressed: () {
            Navigator.pushNamed(
              context,
              SecurityOption.routeName,
            );
          },
          theme: listTileTheme,
        ),
        padding,
        SettingOptions(
          leadingIcon: Icons.offline_bolt_outlined,
          title: 'Quick Setup',
          subtitle: 'Create pre-defined pages quickly',
          onPressed: () {
            //TODO
          },
          theme: listTileTheme,
        ),
        padding,
        SettingOptions(
          leadingIcon: Icons.help_outline,
          title: 'Help',
          subtitle: 'Basic usage guide',
          onPressed: () {
            Navigator.pop(context);
          },
          theme: listTileTheme,
        ),
        padding,
        SettingOptions(
          leadingIcon: Icons.info_outline,
          title: 'App Info',
          onPressed: () {
            Navigator.pop(context);
          },
          theme: listTileTheme,
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

class SettingOptions extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final Function onPressed;
  final ListTileSettingsTheme theme;

  const SettingOptions({
    Key key,
    this.leadingIcon,
    this.title,
    this.subtitle,
    this.onPressed,
    this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: theme.leadingIconColor,
      ),
      title: Text(
        title,
        style: theme.titleStyle,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: theme.contentStyle,
            )
          : null,
      trailing: IconButton(
        icon: Icon(
          Icons.arrow_forward_ios,
          color: context.read<GeneralOptionsCubit>().state.appAccentColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class GeneralOption extends StatelessWidget {
  static const routeName = 'GeneralOptions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Text('Visual'),
          ),
          ListTile(
            title: Text('Theme'),
            leading: Icon(Icons.invert_colors),
            subtitle: Text('Light / Dark'),
            onTap: () {
              context.read<GeneralOptionsCubit>().toggleTheme();
              saveTheme(context
                  .read<GeneralOptionsCubit>()
                  .state
                  .appBrightness
                  .index);
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          ListTile(
            leading: Icon(
              Icons.circle,
              color: Colors.black,
            ),
            title: Text('Accent Color'),
            subtitle: Text('Cyan, Mint, Lime and more'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          ListTile(
            leading: Icon(Icons.title),
            title: Text('Typeface'),
            subtitle: Text('OpenSans / RobotoMono'),
            onTap: () => context.read<GeneralOptionsCubit>(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('Font size'),
            subtitle: Text('Small / Default / Large'),
            onTap: () async {
              context
                  .read<GeneralOptionsCubit>()
                  .changeFontSize(await _showDialog(context));
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          ListTile(
            leading: Icon(Icons.settings_backup_restore),
            title: Text('Reset all Preference'),
            subtitle: Text('Reset all visual Customizations'),
            onTap: context.read<GeneralOptionsCubit>().resetSettings,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Chat Interface'),
          ),
          BlocBuilder<GeneralOptionsCubit, GeneralOptionsState>(
            builder: (context, state) => SwitchListTile(
              secondary: Icon(Icons.date_range),
              title: Text('Date-Time Modification'),
              subtitle: Text('Allows manual date & time for an entry'),
              value: state.isDateTimeModification,
              onChanged: context
                  .read<GeneralOptionsCubit>()
                  .changeDateTimeModification,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          BlocBuilder<GeneralOptionsCubit, GeneralOptionsState>(
            builder: (context, state) => SwitchListTile(
              secondary: Icon(Icons.format_align_right),
              title: Text('Bubble Alignment'),
              subtitle: Text('Force right-to-left bubble alignment'),
              value: state.isLeftBubbleAlign,
              onChanged: context.read<GeneralOptionsCubit>().changeBubbleAlign,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          BlocBuilder<GeneralOptionsCubit, GeneralOptionsState>(
            builder: (context, state) => SwitchListTile(
              secondary: Icon(Icons.wb_iridescent),
              title: Text('Center Date Bubble'),
              value: state.isCenterDateBubble,
              onChanged:
                  context.read<GeneralOptionsCubit>().changeCenterDateBubble,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          SwitchListTile(
            secondary: Icon(Icons.save),
            title: Text('Save Images Locally'),
            subtitle: Text('Save a copy of of image in-app locally'),
            value: false,
            onChanged: (value) => true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          ListTile(
            leading: Icon(Icons.wallpaper),
            title: Text('Background Image'),
            subtitle: Text('Chat background image'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          SwitchListTile(
            secondary: Icon(Icons.mms),
            title: Text('Images Date-time'),
            subtitle: Text('Fetch date & time from when the image was taken'),
            value: false,
            onChanged: (value) => true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          SwitchListTile(
            secondary: Icon(MyFlutterApp.smart_toy_24px),
            title: Text('Hide Questionnaire Bot'),
            value: false,
            onChanged: (value) => true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Reset all pinned pages'),
            subtitle: Text('Unpin all pages'),
          ),
        ],
      ),
    );
  }

  Future<TypeFontSize> _showDialog(BuildContext context) async {
    return await showDialog<TypeFontSize>(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                'Font Size',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text('Small'),
              onTap: () => Navigator.pop(context, TypeFontSize.small),
            ),
            ListTile(
              title: Text('Default'),
              onTap: () => Navigator.pop(context, TypeFontSize.def),
            ),
            ListTile(
              title: Text('Large'),
              onTap: () => Navigator.pop(context, TypeFontSize.large),
            ),
          ],
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
        actions: <Widget>[],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          BlocBuilder<GeneralOptionsCubit, GeneralOptionsState>(
            builder: (context, state) => SwitchListTile(
              secondary: Icon(Icons.mms),
              title: Text('Fingerprint'),
              subtitle: Text('Enable Fingerprint unlock'),
              value: state.isAuthentication,
              onChanged:
                  context.read<GeneralOptionsCubit>().changeAuthentication,
            ),
          ),
        ],
      ),
    );
  }
}
