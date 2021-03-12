import 'package:chat_journal/settings_page/settings_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_theme_cubit.dart';
import '../app_theme_state.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appThemeState = BlocProvider.of<AppThemeCubit>(context).state;
    return Scaffold(
      appBar: _appBar(_appThemeState),
      body: _body(context, _appThemeState),
      backgroundColor: _appThemeState.mainColor,
    );
  }

  Widget _body(BuildContext context, AppThemeState _appThemeState) {
    Widget _header(String text) {
      return Container(
        margin: EdgeInsets.only(left: 20, top: 5),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _appThemeState.mainTextColor,
          ),
        ),
      );
    }

    Widget _tile(IconData icon, String title, String subtitle, Function onTap,
        {Widget trailing}) {
      return ListTile(
        leading: Icon(
          icon,
          color: _appThemeState.mainTextColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: _appThemeState.mainTextColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: _appThemeState.mainTextColor),
        ),
        trailing: trailing,
        onTap: onTap,
      );
    }

    var dateSwitch = Switch(
      value: BlocProvider.of<SettingsCubit>(context).state.isDateCentered,
      onChanged: BlocProvider.of<SettingsCubit>(context).changeDateCentered,
    );

    var bubbleSwitch = Switch(
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
        Divider(color: _appThemeState.mainTextColor),
        _header('Chat'),
        _tile(
          Icons.date_range_outlined,
          'Center date',
          'Display date at the center.',
          () {dateSwitch.onChanged(!dateSwitch.value);},
          trailing: dateSwitch,
        ),
        Divider(color: _appThemeState.mainTextColor),
        _tile(
          Icons.format_align_right,
          'Bubble alignment',
          'Force right-to-left bubble alignment.',
              () {bubbleSwitch.onChanged(!bubbleSwitch.value);},
          trailing: bubbleSwitch,
        ),
        Divider(color: _appThemeState.mainTextColor),
      ],
    );
  }

  Widget _appBar(AppThemeState _appThemeState) {
    return AppBar(
      backgroundColor: _appThemeState.accentColor,
      title: Text(
        'Settings',
        style: TextStyle(color: _appThemeState.accentTextColor),
      ),
    );
  }
}
