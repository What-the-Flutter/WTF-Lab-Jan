import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../util/shared_preferences/shared_preferences_cubit.dart';

class GeneralSettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GeneralSettingPageState();
}

class _GeneralSettingPageState extends State<GeneralSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarFromGeneralSettingsPage(),
      body: _bodyFromGeneralSettingPage(),
    );
  }

  AppBar _appBarFromGeneralSettingsPage() {
    return AppBar(
      title: const Text(
        'General Settings',
        style: TextStyle(color: Colors.yellow),
      ),
      centerTitle: true,
      backgroundColor: Colors.black,
    );
  }

  Widget _bodyFromGeneralSettingPage() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 15, 6, 5),
          child: Card(
            child: ListTile(
              title: const Text('Theme'),
              subtitle: const Text('Light/Dark'),
              leading: const Icon(
                Icons.invert_colors,
                size: 35,
              ),
              onTap: () => context.read<SharedPreferencesCubit>().changeTheme(),
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Bubble Alignment'),
            subtitle: const Text('force right-to-left bubble alignment'),
            leading: const Icon(
              Icons.format_align_left,
              size: 35,
            ),
            onTap: () => context.read<SharedPreferencesCubit>().changeBubbleAlignment(),
          ),
        ),
      ],
    );
  }
}
