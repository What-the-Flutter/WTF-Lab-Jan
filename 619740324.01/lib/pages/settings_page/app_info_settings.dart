import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class AppInfoSettings extends StatefulWidget {
  @override
  _AppInfoSettingsState createState() => _AppInfoSettingsState();
}

class _AppInfoSettingsState extends State<AppInfoSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('App Info'),
      ),
      body: _listView,
    );
  }

  ListView get _listView {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Spread the word'),
          subtitle: const Text('Share the app with your friends'),
          onTap: _share,
        ),
      ],
    );
  }

  void _share() {
    const text = 'You can look at all the code on GitHab:'
        ' https://github.com/DenisHaritonovich ';
    Share.share(text);
  }
}
