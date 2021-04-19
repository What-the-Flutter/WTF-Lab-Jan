import 'package:flutter/material.dart';

import 'notes_list.dart';
import 'questionnaire_bot.dart';

class Body extends StatelessWidget {
  final String title;

  const Body({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          QuestionnaireBot(),
          NotesList(size: size),
        ],
      ),
    );
  }
}
