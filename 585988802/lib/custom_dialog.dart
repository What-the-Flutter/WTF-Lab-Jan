import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_app/event_message.dart';

class CustomDialog extends StatefulWidget {
  final String title, content, firstBtnText, secondBtnText;
  final Icon icon;
  final dynamic firstBtnFunc, secondBtnFunc;
  bool isEditMessage;
  TextEditingController textEditControl;
  EventMessage eventMessage;

  CustomDialog.imageSelect({
    this.title,
    this.content,
    this.firstBtnText,
    this.secondBtnText,
    this.icon,
    this.firstBtnFunc,
    this.secondBtnFunc,
    this.isEditMessage,
  });

  CustomDialog.editEventMessage(
      {this.title,
      this.content,
      this.firstBtnText,
      this.secondBtnText,
      this.icon,
      this.firstBtnFunc,
      this.secondBtnFunc,
      this.isEditMessage,
      this.textEditControl,
      this.eventMessage});

  @override
  _CustomDialog createState() => _CustomDialog(
      title,
      content,
      firstBtnText,
      secondBtnText,
      icon,
      firstBtnFunc,
      secondBtnFunc,
      isEditMessage,
      textEditControl,
      eventMessage);
}

class _CustomDialog extends State<CustomDialog> {
  final String title, content, firstBtnText, secondBtnText;
  final Icon icon;
  final dynamic firstBtnFunc, secondBtnFunc;
  bool isEditMessage;
  TextEditingController textEditControl;
  EventMessage eventMessage;

  _CustomDialog(
      this.title,
      this.content,
      this.firstBtnText,
      this.secondBtnText,
      this.icon,
      this.firstBtnFunc,
      this.secondBtnFunc,
      this.isEditMessage,
      this.textEditControl,
      this.eventMessage);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
            color: Colors.white,
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
                      controller: textEditControl,
                      onChanged: (value) {
                        setState(() {
                          // eventMessage.text = value;
                          // textEditControl.clear();
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          eventMessage.text = value;
                          textEditControl.clear();
                        });
                      },
                    )
                  : Text(
                      content,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
              ButtonBar(
                buttonMinWidth: 100,
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child: Text(firstBtnText),
                    onPressed: () {
                      firstBtnFunc();
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(secondBtnText),
                    onPressed: () {
                      secondBtnFunc();
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
        ),
      ],
    );
  }
}
