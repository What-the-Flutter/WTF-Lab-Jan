import 'package:flutter/material.dart';
import '../models/event_message.dart';

class CustomDialog extends StatelessWidget {
  final String title, content, firstBtnText, secondBtnText;
  final Icon icon;
  final dynamic firstBtnFunc, secondBtnFunc;
  final bool isEditMessage;
  final bool isDeleteMessage;
  final String nameOfSuggestion;
  final TextEditingController textEditControl;
  final EventMessage eventMessage;

  CustomDialog.imageSelect({
    this.title,
    this.content,
    this.firstBtnText,
    this.secondBtnText,
    this.icon,
    this.firstBtnFunc,
    this.secondBtnFunc,
    this.isEditMessage = false,
    this.isDeleteMessage = false,
    this.nameOfSuggestion,
    this.textEditControl,
    this.eventMessage,
  });

  CustomDialog.deleteEventMessage({
    this.title,
    this.content,
    this.firstBtnText,
    this.secondBtnText,
    this.icon,
    this.firstBtnFunc,
    this.secondBtnFunc,
    this.isEditMessage = false,
    this.isDeleteMessage = true,
    this.nameOfSuggestion,
    this.textEditControl,
    this.eventMessage,
  });

  CustomDialog.editEventMessage({
    this.title,
    this.content,
    this.firstBtnText,
    this.secondBtnText,
    this.icon,
    this.firstBtnFunc,
    this.secondBtnFunc,
    this.isEditMessage = true,
    this.isDeleteMessage = false,
    this.textEditControl,
    this.eventMessage,
    this.nameOfSuggestion,
  });

  CustomDialog.editSuggestion({
    this.title,
    this.content,
    this.firstBtnText,
    this.secondBtnText,
    this.icon,
    this.firstBtnFunc,
    this.secondBtnFunc,
    this.isEditMessage = true,
    this.isDeleteMessage = false,
    this.textEditControl,
    this.nameOfSuggestion,
    this.eventMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: BorderRadius.circular(25.0),
          ),
          padding: EdgeInsets.only(top: 60, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.headline5,
              ),
              isEditMessage
                  ? Container()
                  : SizedBox(
                      height: 16,
                    ),
              isEditMessage
                  ? TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter text',
                      ),
                      controller: textEditControl,
                    )
                  : Text(
                      content,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
              ButtonBar(
                buttonMinWidth: 100,
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: Text(
                      firstBtnText,
                      style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                    onPressed: () {
                      firstBtnFunc();
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      secondBtnText,
                      style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                    onPressed: () {
                      secondBtnFunc();
                      Navigator.of(context).pop();
                    },
                  ),
                  (isEditMessage || isDeleteMessage)
                      ? Container()
                      : TextButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                ],
              ),
            ],
          ),
        ),
        CircleAvatar(
          maxRadius: 40.0,
          child: icon,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ],
    );
  }
}
