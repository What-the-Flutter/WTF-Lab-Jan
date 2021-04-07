import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/theme/custom_theme.dart' as my;
import '../settings_screen/general_options_cubit.dart';

class CustomListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final Function onTap;
  final my.ListTileTheme theme;
  final Widget trailing;

  const CustomListTile({
    Key key,
    this.leadingIcon,
    this.title,
    this.subtitle,
    this.onTap,
    this.theme,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
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
        trailing: trailing);
  }
}
