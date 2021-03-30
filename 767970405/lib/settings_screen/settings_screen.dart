import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/custom_icon/my_flutter_app_icons.dart';
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
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          child: Divider(),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        ListTile(
          leading: Icon(Icons.nature_people),
          title: Text('General'),
          subtitle: Text('Themes & Interface settings'),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.pushNamed(
                context,
                GeneralOption.routeName,
              );
            },
          ),
        ),
        Padding(
          child: Divider(),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        ListTile(
          leading: Icon(Icons.cloud),
          title: Text('Backup & Sync'),
          subtitle: Text('Local & Drive backup & sync'),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              //TODO
            },
          ),
        ),
        Padding(
          child: Divider(),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        ListTile(
          leading: Icon(Icons.archive),
          title: Text('Exports'),
          subtitle: Text('Textual backup of all your entries'),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              //TODO
            },
          ),
        ),
        Padding(
          child: Divider(),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('Security'),
          subtitle: Text('Pin & Fingerprint protection'),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.pushNamed(
                context,
                SecurityOption.routeName,
              );
            },
          ),
        ),
        Padding(
          child: Divider(),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        ListTile(
          leading: Icon(Icons.offline_bolt_outlined),
          title: Text('Quick Setup'),
          subtitle: Text('Create pre-defined pages quickly'),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              //TODO
            },
          ),
        ),
        Padding(
          child: Divider(),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        ListTile(
          leading: Icon(Icons.help_outline),
          title: Text('Help'),
          subtitle: Text('Basic usage guide'),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          child: Divider(),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('App Info'),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          child: Divider(),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ],
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
        title: Center(
          child: Text('General'),
        ),
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
              saveTheme(
                  context.read<GeneralOptionsCubit>().state.themeType.index);
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
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('Font size'),
            subtitle: Text('Small / Default / Large'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          ListTile(
            leading: Icon(Icons.settings_backup_restore),
            title: Text('Reset all Preference'),
            subtitle: Text('Reset all visual Customizations'),
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
