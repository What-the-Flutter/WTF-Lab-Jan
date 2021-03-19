import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_model.dart';
import 'setting_page_cubit.dart';

bool isSwitched = true;

class SettingsPage extends StatelessWidget {
  static const routeName = '/SettingsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 40),
            child: Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<SettingPageCubit,SettingsPageState>(
            builder: (context,state) => _body(context),
        ),
    );
  }

  Widget _body(BuildContext context) {
    Widget _setting(IconData icon, String title, String subtitle,
        {Function onTap, Widget switching}) {
      return ListTile(
        leading: Icon(
          icon,
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        subtitle: Text(
          subtitle,
        ),
        onTap: onTap,
        trailing: Container(
          width: 60,
            child: switching,
        ),
      );
    }

    var dateSwitch = Switch(
      value: BlocProvider.of<SettingPageCubit>(context)
          .state
          .isDateModificationSwitched ?? false,
      onChanged:
          BlocProvider.of<SettingPageCubit>(context).changeDateModification,
    );

    var bubbleSwitch = Switch(
      value: BlocProvider.of<SettingPageCubit>(context)
          .state
          .isBubbleAlignmentSwitched ?? false,
      onChanged:
          BlocProvider.of<SettingPageCubit>(context).changeBubbleAlignment,
    );

    var dateBubbleSwitch = Switch(
      value: BlocProvider.of<SettingPageCubit>(context)
          .state
          .isDateAlignmentSwitched ?? false,
      onChanged: BlocProvider.of<SettingPageCubit>(context).changeDateAlignment,
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _setting(
              Icons.invert_colors,
              'Theme',
              'Light / Dark',
              onTap:
                  Provider.of<ThemeModel>(context, listen: false).changeTheme,
            ),
            _setting(
              Icons.calendar_today_outlined,
              'Date-Time Modification',
              'Allows manual date & time for an entry',
              onTap: () {
                dateSwitch.onChanged(dateSwitch.value);
              },
              switching: dateSwitch,
            ),
            _setting(
              Icons.format_align_left,
              'Bubble Alignment',
              'Force right-to-left bubble alignment',
              switching: bubbleSwitch,
              onTap: () {
                bubbleSwitch.onChanged(!bubbleSwitch.value);
              },
            ),
            _setting(
              Icons.wb_iridescent,
              'Center Date Bubble',
              'Force right-to-left date bubble alignment',
              switching: dateBubbleSwitch,
              onTap: () {
                dateBubbleSwitch.onChanged(!dateBubbleSwitch.value);
              },
            ),
          ],
        ),
      ),
    );
  }
}