import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'create_new_page.dart';

class ButtonAddChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 10.0,
      child: Icon(
        Icons.add,
        color: Colors.black,
      ),
      onPressed: () {
        Navigator.pushNamed(
          context,
          CreateNewPage.routName,
        );
      },
    );
  }
}
