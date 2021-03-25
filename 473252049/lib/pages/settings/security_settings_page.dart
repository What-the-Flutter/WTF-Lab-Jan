import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'cubit/settings_cubit.dart';

class SecuritySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Security settings'),
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return ListView(
              children: [
                if (Platform.isIOS || Platform.isAndroid)
                  SwitchListTile(
                    title: Text('Turn on authentication'),
                    subtitle: Text('Biometric and password authentication'),
                    value: state.isAuthenticationOn,
                    onChanged: (value) {
                      context.read<SettingsCubit>().switchAuthenticationOn();
                    },
                  ),
              ],
            );
          },
        ));
  }
}
