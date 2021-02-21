import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'customIcon/my_flutter_app_icons.dart';
import 'event_page.dart';
import 'list_item.dart';
import 'theme.dart';
import 'theme_model.dart';

class ChatPages extends StatefulWidget {
  static List<PropertyPage> pages = <PropertyPage>[
    PropertyPage(Icons.book_sharp, 'Journal', <ListItem<String>>[]),
    PropertyPage(Icons.import_contacts_rounded, 'Notes', <ListItem<String>>[]),
    PropertyPage(Icons.nature_people, 'Gratitude', <ListItem<String>>[]),
  ];

  @override
  _ChatPagesState createState() => _ChatPagesState();
}

class _ChatPagesState extends State<ChatPages> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: ChatPages.pages.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) return _buildBot();
          return EventPage(i - 1, _removeItem);
        },
        separatorBuilder: (context, index) => Divider());
  }

  void _removeItem(int index) {
    setState(() {
      ChatPages.pages.removeAt(index);
    });
  }

  Widget _buildBot() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            MyFlutterApp.smart_toy_24px,
            size: 30,
          ),
          Text(
            'Questionnaire Bot',
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Provider.of<ThemeModel>(context).currentTheme == darkTheme
            ? Colors.black
            : Colors.green[50],
      ),
      margin: EdgeInsetsDirectional.only(start: 30.0, top: 5.0, end: 30.0),
      width: 200,
      height: 50,
    );
  }
}
