import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

import '../../app_theme_cubit.dart';
import 'labels_page/labels_page.dart';
import 'settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget _body(BuildContext context) {
    Widget _header(String text) {
      return Container(
        margin: EdgeInsets.only(left: 20, top: 5),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1.color,
            fontWeight: FontWeight.bold,
            fontSize: SettingsCubit.calculateSize(context, 15, 18, 25),
          ),
        ),
      );
    }

    Widget _tile(IconData icon, String title, String subtitle, Function onTap,
        {Widget trailing}) {
      return ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).textTheme.bodyText1.color,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1.color,
            fontSize: SettingsCubit.calculateSize(context, 18, 20, 23),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.8),
            fontWeight: FontWeight.normal,
            fontSize: SettingsCubit.calculateSize(context, 15, 18, 25),
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      );
    }

    final dateSwitch = Switch(
      value: BlocProvider.of<SettingsCubit>(context).state.isDateCentered,
      onChanged: BlocProvider.of<SettingsCubit>(context).changeDateCentered,
    );

    final bubbleSwitch = Switch(
      value: BlocProvider.of<SettingsCubit>(context).state.isRightToLeft,
      onChanged: BlocProvider.of<SettingsCubit>(context).changeRightToLeft,
    );

    return ListView(
      physics: ScrollPhysics(),
      children: [
        _header('Visuals'),
        _tile(
          Icons.color_lens_outlined,
          'Theme',
          'Light/Dark',
          BlocProvider.of<AppThemeCubit>(context).changeTheme,
        ),
        _divider(context),
        _header('General'),
        _tile(
          Icons.date_range_outlined,
          'Center date',
          'Display date at the center.',
          () {
            dateSwitch.onChanged(!dateSwitch.value);
          },
          trailing: dateSwitch,
        ),
        _divider(context),
        _tile(
          Icons.format_align_right,
          'Bubble alignment',
          'Force right-to-left bubble alignment.',
          () {
            bubbleSwitch.onChanged(!bubbleSwitch.value);
          },
          trailing: bubbleSwitch,
        ),
        _divider(context),
        _tile(
          Icons.sort_by_alpha,
          'Font size',
          'Small/Medium/Large',
          () => BlocProvider.of<SettingsCubit>(context).changeFontSize(),
        ),
        _divider(context),
        _tile(
          Icons.label_outline,
          'Label management',
          'Create new label or edit created one',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LabelsPage(),
              ),
            );
          },
        ),
        _header('Other'),
        _tile(
          Icons.settings_backup_restore_outlined,
          'Restore settings',
          'Reset all setting to default values',
          () {
            BlocProvider.of<SettingsCubit>(context).reset();
            if (!BlocProvider.of<AppThemeCubit>(context)
                .state
                .usingLightTheme) {
              BlocProvider.of<AppThemeCubit>(context).changeTheme();
            }
          },
        ),
        _divider(context),
        _tile(
          Icons.share,
          'Share app',
          'Share a link of the Chat journal with your friends!',
          () {
            Share.share(
                'Join us right now and download Chat journal! \n\r https://t.me/joinchat/yjKwXnOttL5kMGNi');
          },
        ),
      ],
    );
  }

  Divider _divider(BuildContext context) =>
      Divider(color: Theme.of(context).dividerColor.withOpacity(0.2));

  Widget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: Theme.of(context).accentIconTheme,
      title: Text(
        'Settings',
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText2.color,
          fontWeight: FontWeight.bold,
          fontSize: SettingsCubit.calculateSize(context, 15, 20, 30),
        ),
      ),
    );
  }
}
