import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/cubit_theme.dart';

class GeneralSettingsPage extends StatefulWidget {
  @override
  _GeneralSettingsPageState createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _bodyGeneralSettings(),
    );
  }

  ListView _bodyGeneralSettings() {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.invert_colors),
          title: const Text('Theme'),
          subtitle: const Text('Light/Dark'),
          onTap: () => BlocProvider.of<CubitTheme>(context).changeTheme(),
        ),
        ListTile(
          leading: const Icon(Icons.format_size),
          title: const Text('Front Size'),
          subtitle: const Text('Small / Default / Large'),
          onTap: () {},
        ),
        const ListTile(
          leading: Icon(Icons.calendar_today_outlined),
          title: Text('Date-Time Modification'),
          subtitle: Text('Allows manual date & time for an entry'),
        ),
        ListTile(
          leading: const Icon(Icons.replay),
          title: const Text('Reset All Preferences'),
          subtitle: const Text('Reset all Visual Customization'),
          onTap: () {},
        ),
      ],
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: const Text('General'),
    );
  }
}
