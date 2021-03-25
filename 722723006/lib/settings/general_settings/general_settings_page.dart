import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_page/theme/dark_theme.dart';
import 'package:home_page/theme/light_theme.dart';
import 'package:home_page/theme/theme.dart';
import '../../data/shared_preferences_provider.dart';
import 'general_settings_cubit.dart';

class GeneralSettingsPage extends StatefulWidget {
  @override
  _GeneralSettingsPageState createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  final GeneralSettingsCubit _cubit =
      GeneralSettingsCubit(GeneralSettingsStates());
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('General'),
          ),
          body: _bodyListView,
        );
      },
    );
  }

  ListView get _bodyListView {
    return ListView(
      padding: EdgeInsets.only(top: 10),
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
              leading: Icon(Icons.invert_colors),
              title: Text('Theme'),
              subtitle: Text('Light / Dark'),
              onTap: () {
                _cubit.state.isThemeChange
                    ? ThemeSwitcher.of(context).switchTheme(darkTheme)
                    : ThemeSwitcher.of(context).switchTheme(lightTheme);
                _cubit.setThemeChangeState(!_cubit.state.isThemeChange);
              }),
          ListTile(
            leading: Icon(Icons.calendar_today_outlined),
            trailing: Switch(
              value:
                  SharedPreferencesProvider().fetchDateTimeModificationState(),
              onChanged: (isDateTimeModification) {
                _cubit.setDateTimeModificationState(isDateTimeModification);
              },
            ),
            title: Text('Date-Time Modification'),
            subtitle: Text('Allows manual date & time for an entry'),
          ),
          ListTile(
            leading: Icon(Icons.format_align_right),
            trailing: Switch(
              value: SharedPreferencesProvider().fetchBubbleAlignmentState(),
              onChanged: (isBubbleAlignment) {
                _cubit.setBubbleAlignmentState(isBubbleAlignment);
              },
            ),
            title: Text('Bubble Alignment'),
            subtitle: Text('Force right-to-left bubble alignment'),
          ),
          ListTile(
            leading: Icon(Icons.vertical_align_center),
            trailing: Switch(
              value: SharedPreferencesProvider().fetchCenterDateBubbleState(),
              onChanged: (isCenterDateBubble) {
                _cubit.setCenterDateBubbleState(isCenterDateBubble);
              },
            ),
            title: Text('Center Date Bubble'),
          ),
        ],
      ).toList(),
    );
  }
}
