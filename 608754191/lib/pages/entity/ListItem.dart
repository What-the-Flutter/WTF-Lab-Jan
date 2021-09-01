import 'package:flutter/material.dart';

class MyListItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData iconData;

  @override
  _MyListItemState createState() => _MyListItemState();
  MyListItem(this.title, this.subtitle, this.iconData);
}

class _MyListItemState extends State<MyListItem> {
  String get title => this.title;

  String get subtitle => this.subtitle;

  IconData? get iconData => this.iconData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text(title), Text(subtitle), Icon(iconData)],
    );
  }
}

class ListItem {
  final String title;
  final String subtitle;
  final IconData iconData;
  ListItem(this.title, this.subtitle, this.iconData);
}
