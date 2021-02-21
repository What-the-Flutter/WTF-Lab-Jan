import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'create_new_page.dart';

class ButtonAddChat extends StatelessWidget {
  final _addPage;

  ButtonAddChat(this._addPage);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 10.0,
      child: Icon(
        Icons.add,
        color: Colors.black,
      ),
      onPressed: () async {
        final result = await Navigator.pushNamed(
          context,
          CreateNewPage.routName,
        );
        _addPage(result);
      },
    );
  }
}
