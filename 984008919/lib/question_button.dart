import 'package:flutter/material.dart';

class QuestionnareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: ElevatedButton.icon(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.green.shade200)),
          icon: Icon(Icons.android, color: Colors.black),
          onPressed: () {},
          label:
              Text('Questionnaire Bot', style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}
