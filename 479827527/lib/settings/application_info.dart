import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ApplicationInfo extends StatefulWidget {
  @override
  _ApplicationInfoState createState() => _ApplicationInfoState();
}

class _ApplicationInfoState extends State<ApplicationInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Application info',
        ),
      ),
      body: _listTile,
    );
  }

  ListTile get _listTile {
    return ListTile(
      leading: Icon(
        Icons.share,
        size: 35,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        'Spread the word',
      ),
      subtitle: Text(
        'Share the app with your friends',
      ),
      onTap: () => Share.share(
        'For all questions, please contact this link:\n'
        'https://vk.com/sashaguzich',
      ),
    );
  }
}
