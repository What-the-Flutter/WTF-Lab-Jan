import 'package:flutter/material.dart';
import 'list_messages.dart';

class ListOfCategories extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;

  ListOfCategories(this.title, this.subtitle, this.iconData);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text(title), Text(subtitle), Icon(iconData)],
    );
  }
}

class Category {
  final String title;
  final String subtitle;
  final IconData iconData;
  List<Message> listMessages;

  Category(this.title, this.subtitle, this.iconData, this.listMessages);
}
