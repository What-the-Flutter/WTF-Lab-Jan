import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/screens/add_new_chat/add_new_chat.dart';
import '/screens/settings/settings_cubit.dart';
import '/screens/statistic_screen/statistic_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<SettingsCubit>(context).state;

    return Drawer(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 70),
            _drawerButton(
              BlocProvider.of<SettingsCubit>(context).share,
              'Help spread the word',
              state,
            ),
            const SizedBox(height: 20),
            _drawerButton(
              () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNewChat(addCategory: true),
                  ),
                );
              },
              'Add Category',
              state,
            ),
            const SizedBox(height: 20),
            _drawerButton(
              BlocProvider.of<SettingsCubit>(context).changeBubbleChatSide,
              'Change Chat Side',
              state,
            ),
            const SizedBox(height: 20),
            _drawerButton(
              BlocProvider.of<SettingsCubit>(context).changeDateAlign,
              'Change Date Align',
              state,
            ),
            const SizedBox(height: 20),
            _drawerButton(
              BlocProvider.of<SettingsCubit>(context).addBGImage,
              'Change Chat Background Image',
              state,
            ),
            const SizedBox(height: 20),
            _drawerButton(
              BlocProvider.of<SettingsCubit>(context).resetBGImage,
              'Delete Chat Background Image',
              state,
            ),
            const SizedBox(height: 20),
            _drawerButton(
              () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatisticsScreen(),
                  ),
                );
              },
              'Statistics',
              state,
            ),
            const SizedBox(height: 20),
            _drawerDropdownButton(state),
            const Spacer(),
            _drawerButton(
              BlocProvider.of<SettingsCubit>(context).resetSettings,
              'Reset Settings',
              state,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _drawerDropdownButton(SettingsState state) {
    final textStyle = TextStyle(fontSize: state.fontSize, color: Colors.yellow);

    return DropdownButton(
      hint: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 250),
        style: textStyle,
        child: Text(state.fontSizeString),
      ),
      items: ['Small', 'Medium', 'Large'].map(buildMenuItem).toList(),
      onChanged: (size) {
        setState(() {});
        BlocProvider.of<SettingsCubit>(context).changeFontSize(size.toString());
      },
    );
  }

  Widget _drawerButton(Function onPressed, String text, SettingsState state) {
    final textStyle = TextStyle(fontSize: state.fontSize, color: Colors.yellow);

    return ElevatedButton(
      onPressed: () => onPressed(),
      child: AnimatedDefaultTextStyle(
        style: textStyle,
        duration: const Duration(milliseconds: 250),
        child: Text(text),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(
          fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
        ),
      ),
    );
  }
}
