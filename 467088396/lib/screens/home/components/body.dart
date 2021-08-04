import 'package:flutter/material.dart';

import 'header_chat_button.dart';
import 'category_list.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        BotButton(size: size),
        CategoryList()
      ],
    );
  }
}

