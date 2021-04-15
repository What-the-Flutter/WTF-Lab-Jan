import 'package:flutter/material.dart';

Widget questionnaireBot(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
      left: 40,
      top: 10,
      bottom: 10,
      right: 40,
    ),
    child: Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).accentColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.android,
            color: Colors.black,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            'Questionnaire Bot',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    ),
  );
}
