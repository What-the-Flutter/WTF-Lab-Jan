import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main/tabs/home/cubit/categories_cubit.dart';
import 'general_settings_page.dart';
import 'security_settings_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('General'),
            subtitle: Text('Themes & Interface settings'),
            leading: Icon(Icons.design_services_outlined),
            trailing: Icon(arrowForward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (newContext) {
                    return BlocProvider.value(
                      value: context.read<CategoriesCubit>(),
                      child: GeneralSettingPage(),
                    );
                  },
                ),
              );
            },
          ),
          ListTile(
            title: Text('Security'),
            subtitle: Text('Security & Privacy settings'),
            leading: Icon(Icons.security),
            trailing: Icon(arrowForward),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return SecuritySettingsPage();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

IconData arrowForward =
    Platform.isIOS ? Icons.arrow_forward_ios : Icons.arrow_forward;
