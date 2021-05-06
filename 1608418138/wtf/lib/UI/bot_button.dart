import 'package:flutter/material.dart';

class BotButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      height: scHeight/10,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Theme.of(context).accentColor,
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.android_outlined),
              Text('Questionnare Bot')
            ].map((e)=>Padding(child: e,padding: EdgeInsets.all(10),)).toList(),
          ),
        ),
      ),
    );
  }

}
