import 'package:chat_journal/model/record.dart';
import 'package:chat_journal/pages/category_chat_page.dart';
import 'package:chat_journal/pages/content/home_page_content.dart';
import 'package:chat_journal/views/chat_view.dart';
import 'package:chat_journal/views/record_view.dart';
import 'package:flutter/material.dart';

final createMessageViewStateKey = GlobalKey<_CreateMessageViewState>();

class CreateMessageView extends StatefulWidget {
  CreateMessageView({Key key}) : super(key: key);

  @override
  _CreateMessageViewState createState() => _CreateMessageViewState();
}

final textFieldController = TextEditingController();
final formKey = GlobalKey<FormState>();

class _CreateMessageViewState extends State<CreateMessageView> {
  final _formKey = formKey;
  final _textEditingController = TextEditingController();
  var isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter Event',
                ),
                controller: textFieldController,
                maxLines: null,
              ),
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
                  if (isEditing) {
                    categoryChatPage.category.highlightedRecords.first.message =
                        textFieldController.text;
                    categoryChatPage.category.unhighlight();
                    isEditing = false;
                  } else {
                    categoryChatPageStateKey.currentState.widget.category
                        .addRecord(Record(textFieldController.text));
                  }
                  updateCategoryChatPage();
                  textFieldController.clear();
                  homePageContentStateKey.currentState.setState(() {});
                  print(categoryChatPage.category.records.length);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
