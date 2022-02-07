import 'package:flutter/material.dart';
import '../../database/firebase_db_helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const routeName = '/pageSettings';
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Settings')),
      ),
      body: ElevatedButton(
        child: const Text('sign in anon'),
        onPressed: () async {
          dynamic result = await _auth.signInAnon();
          if (result == null) {
            print('error signing in');
          } else {
            print('signed in');
            print(result);
          }
        },
      ),
    );
  }
}
