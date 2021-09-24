import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../color_theme_cubit.dart';
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
        margin: const EdgeInsets.only(left: 20, top: 5),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    Widget _tile(IconData icon, String title, String subtitle, Function() onTap,
        {Widget? trailing}) {
      return ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.8),
            fontWeight: FontWeight.normal,
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
      physics: const ScrollPhysics(),
      children: [
        _header('Visuals'),
        _tile(
          Icons.color_lens_outlined,
          'Theme',
          'Light/Dark',
          BlocProvider.of<ColorThemeCubit>(context).changeTheme,
        ),
        Divider(color: Theme.of(context).dividerColor),
        _header('General'),
        _tile(
          Icons.date_range_outlined,
          'Center date',
          'Display date at the center.',
          () {
            dateSwitch.onChanged!(!dateSwitch.value);
          },
          trailing: dateSwitch,
        ),
        Divider(color: Theme.of(context).dividerColor),
        _tile(
          Icons.format_align_right,
          'Bubble alignment',
          'Force right-to-left bubble alignment.',
          () {
            bubbleSwitch.onChanged!(!bubbleSwitch.value);
          },
          trailing: bubbleSwitch,
        ),
      ],
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: Theme.of(context).accentIconTheme,
      title: Text(
        'Settings',
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText2!.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
