import 'package:flutter/material.dart';
import 'package:share/share.dart';

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
        title: Text('App Info'),
      ),
      body: _listView,
    );
  }

  ListView get _listView {
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Spread the word'),
            subtitle: Text('Share the app with your friends'),
            onTap: share,
          ),
        ],
      ).toList(),
    );
  }

  void share() {
    const text = 'For all questions, please contact this link:'
        ' https://vk.com/nikitossssb';
    Share.share(text);
  }
}
