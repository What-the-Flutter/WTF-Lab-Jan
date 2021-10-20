import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/theme_cubit.dart';
import '../events/events_cubit.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Settings'),
        ),
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => context.read<ThemeCubit>().changeTheme(),
            child: _listElement(
              context,
              name: 'Dark Mode',
              icon: context.read<ThemeCubit>().isDarkMode
                  ? Icons.dark_mode
                  : Icons.dark_mode_outlined,
              value: context.read<ThemeCubit>().isDarkMode,
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () => setState(() {
              context.read<EventsCubit>().changeDateModifiable();
            }),
            child: _listElement(
              context,
              name: 'Date-Time Modification',
              icon: Icons.access_time_outlined,
              value: context.read<EventsCubit>().state.isDateModifiable,
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () => setState(() {
              context.read<EventsCubit>().changeBubbleAlignment();
            }),
            child: _listElement(
              context,
              name: 'Bubble Alignment',
              icon: context.read<EventsCubit>().state.isBubbleAlignmentRight
                  ? Icons.format_align_right_outlined
                  : Icons.format_align_left_outlined,
              value: context.read<EventsCubit>().state.isBubbleAlignmentRight,
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () => setState(() {
              context.read<EventsCubit>().changeDateAlignment();
            }),
            child: _listElement(
              context,
              name: 'Center Date Bubble',
              icon: Icons.date_range_outlined,
              value: context.read<EventsCubit>().state.isCenterDateBubble,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Container _listElement(BuildContext context,
      {required String name, required IconData icon, required bool value}) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Icon(icon, size: 25),
          ),
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            flex: 2,
            child: Switch(
              value: value,
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}
