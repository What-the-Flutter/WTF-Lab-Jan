import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widgets/change_theme_button_widget.dart';
import '../../theme/theme_bloc.dart';
import 'setting_screen_event.dart';
import 'settings_screen_bloc.dart';
import 'settings_screen_state.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingScreenBloc, SettingsScreenState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor:
              BlocProvider.of<ThemeBloc>(context).state == ThemeMode.dark
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Theme.of(context).primaryColor,
          appBar: _appBar(context),
          body: _body(context),
        );
      },
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: Container(
        child: Text(
          'Settings',
          style: TextStyle(
            color: BlocProvider.of<ThemeBloc>(context).state == ThemeMode.dark
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
          ),
        ),
        alignment: Alignment.centerLeft,
      ),
      elevation: 5.0,
    );
  }

  ListView _body(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
          child: Text(
            'Visuals',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 20,
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
        Divider(
          color: Colors.black54,
          height: 0.5,
          thickness: 0.5,
          indent: 15,
          endIndent: 15,
        ),
        ListTile(
          leading: Icon(CupertinoIcons.circle_righthalf_fill),
          title: Text(
            'Theme',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          subtitle: Text(
            'Light / Dark',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: ChangeThemeButtonWidget(),
        ),
        Container(
          margin: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
          child: Text(
            'Chat Interface',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 20,
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
        Divider(
          color: Colors.black54,
          height: 0.5,
          thickness: 0.5,
          indent: 15,
          endIndent: 15,
        ),
        ListTile(
          leading: Icon(Icons.format_align_left),
          title: Text(
            'Bubble Alignment',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          subtitle: Text(
            'Swap right-to-left bubble alignment',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: Switch.adaptive(
            value: BlocProvider.of<SettingScreenBloc>(context)
                .state
                .isLeftBubbleAlignment,
            onChanged: (value) {
              BlocProvider.of<SettingScreenBloc>(context).add(
                ChangeBubbleAlignmentEvent(),
              );
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.date_range),
          title: Text(
            'Date-time modification',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          subtitle: Text(
            'Allows manual date and time for an entry',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: Switch.adaptive(
            value: BlocProvider.of<SettingScreenBloc>(context)
                .state
                .isDateTimeModification,
            onChanged: (value) {
              BlocProvider.of<SettingScreenBloc>(context).add(
                ChangeDateTimeModificationEvent(),
              );
            },
          ),
        ),
      ],
    );
  }
}
