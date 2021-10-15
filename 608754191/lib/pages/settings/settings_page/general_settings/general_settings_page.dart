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
            child: _buildSettingsItem(
              title: 'Theme',
              subtitle: 'Light/Dark',
              icon: Icons.invert_colors,
              onClicked: () => context.read<SharedPreferencesCubit>().changeTheme(),
            ),
          ),
        ),
        Card(
          child: _buildSettingsItem(
            title: 'Bubble Alignment',
            subtitle: 'force right-to-left bubble alignment',
            icon: Icons.format_align_left,
            onClicked: () => context.read<SharedPreferencesCubit>().changeBubbleAlignment(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onClicked,
  }) {
    final color = Colors.black;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
        size: 35,
      ),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: color),
      ),
      onTap: onClicked,
    );
  }
}
