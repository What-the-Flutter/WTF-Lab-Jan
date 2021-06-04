import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/theme.dart';
import 'theme/theme_cubit.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        elevation: 0,
        actions: [],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dark Theme',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Switch(
              value: themeCubit.state.themes.isDark,
              onChanged: themeCubit.changeTheme,
            ),
          ],
        ),
      ),
    );
  }
}
