import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'question_button.dart';

class FirstPage extends StatelessWidget {
  final List<String> items =
      List<String>.generate(20, (index) => 'Items$index');
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          backgroundColor: Colors.green,
          title: Text('Home'),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.nightlight_round)),
          ],
        )
      ],
      body: Column(
        children: <Widget>[
          QuestionnareButton(),
        ],
      ),
    );
  }
}

// ListView.separated(
// scrollDirection: Axis.vertical,
// shrinkWrap: true,
// itemCount: items.length,
// separatorBuilder: (BuildContext context, int index) =>
// SizedBox(height: 10.0),
// itemBuilder: (BuildContext context, int index) {
// return ListTile(
// title: Text(items[index]),
// );
// },
// ),
