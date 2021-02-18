import 'package:chat_journal/model/record.dart';
import 'package:chat_journal/pages/content/home_page_content.dart';
import 'package:chat_journal/views/chat_view.dart';
import 'package:flutter/material.dart';

class CreateMessageView extends StatefulWidget {
  @override
  _CreateMessageViewState createState() => _CreateMessageViewState();
}

class _CreateMessageViewState extends State<CreateMessageView> {
  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: AspectRatio(
              aspectRatio: 1,
              child: TextButton(
                child: Icon(Icons.photo_camera),
                onPressed: () {},
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter Event',
              ),
              controller: _textEditingController,
            ),
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: AspectRatio(
              aspectRatio: 1,
              child: TextButton(
                child: Icon(Icons.send),
                onPressed: () {
                  addRecord(Record(_textEditingController.text));
                  _textEditingController.clear();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void addRecord(Record record) {
  chatViewStateKey.currentState.setState(() {
    chatViewStateKey.currentState.widget.category.addRecord(record);
  });
  homePageContentStateKey.currentState.setState(() {});
}
