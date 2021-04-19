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
      children: [
        ListTile(
          leading: Icon(Icons.share),
          title: Text('Spread the word'),
          subtitle: Text('Share the app with your friends'),
          onTap: share,
        ),
      ],
    );
  }

  void share() {
    const text = 'You can look at all the code on GitHab:'
        ' https://github.com/DenisHaritonovich ';
    Share.share(text);
  }
}
