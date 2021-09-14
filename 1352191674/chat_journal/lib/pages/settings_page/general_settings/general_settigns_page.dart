import 'package:chat_journal/services/theme_bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'general_settings_cubit.dart';

class GeneralSettingsPage extends StatefulWidget {
  @override
  _GeneralSettingsPageState createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneralSettingsCubit, GeneralSettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('General'),
          ),
          body: _bodyListView(state),
        );
      },
    );
  }

  @override
  void initState() {
    BlocProvider.of<GeneralSettingsCubit>(context).initStates();
    super.initState();
  }

  ListView _bodyListView(GeneralSettingsState state) {
    return ListView(
      padding: EdgeInsets.only(top: 10),
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            leading: Icon(Icons.invert_colors),
            title: Text('Theme'),
            subtitle: Text('Light / Dark'),
            onTap: () => BlocProvider.of<ThemeCubit>(context).changeTheme(),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today_outlined),
            trailing: Switch(
              value: state.isDateTimeModification!,
              onChanged: BlocProvider.of<GeneralSettingsCubit>(context)
                  .setDateTimeModificationState,
            ),
            title: Text('Date-Time Modification'),
            subtitle: Text('Allows manual date & time for an entry'),
          ),
          ListTile(
            leading: Icon(Icons.format_align_right),
            trailing: Switch(
              value: state.isBubbleAlignment!,
              onChanged: BlocProvider.of<GeneralSettingsCubit>(context)
                  .setBubbleAlignmentState,
            ),
            title: Text('Bubble Alignment'),
            subtitle: Text('Force right-to-left bubble alignment'),
          ),
          ListTile(
            leading: Icon(Icons.vertical_align_center),
            trailing: Switch(
              value: state.isCenterDateBubble!,
              onChanged: BlocProvider.of<GeneralSettingsCubit>(context)
                  .setCenterDateBubbleState,
            ),
            title: Text('Center Date Bubble'),
          ),
        ],
      ).toList(),
    );
  }
}