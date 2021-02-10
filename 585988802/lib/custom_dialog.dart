import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_theme_provider.dart';
import 'event_message.dart';

// ignore: must_be_immutable
class CustomDialog extends StatefulWidget {
  final String title, content, firstBtnText, secondBtnText;
  final Icon icon;
  final dynamic firstBtnFunc, secondBtnFunc;
  final bool isEditMessage;
  String nameOfSuggestion;
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

  CustomDialog.editEventMessage({
    this.title,
    this.content,
    this.firstBtnText,
    this.secondBtnText,
    this.icon,
    this.firstBtnFunc,
    this.secondBtnFunc,
    this.isEditMessage,
    this.textEditControl,
    this.eventMessage,
  });

  CustomDialog.editSuggestion({
    this.title,
    this.content,
    this.firstBtnText,
    this.secondBtnText,
    this.icon,
    this.firstBtnFunc,
    this.secondBtnFunc,
    this.isEditMessage,
    this.textEditControl,
    this.nameOfSuggestion,
  });

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
        eventMessage,
      );
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
    this.eventMessage,
  );

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
            color: Provider.of<ThemeProvider>(context).isDarkMode
                ? Color.fromRGBO(151, 157, 155, 1)
                : Theme.of(context).primaryColor,
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
                alignment: isEditMessage
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      firstBtnText,
                      style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                    onPressed: () {
                      firstBtnFunc();
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      secondBtnText,
                      style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                    onPressed: () {
                      secondBtnFunc();
                      Navigator.of(context).pop();
                    },
                  ),
                  isEditMessage
                      ? Container()
                      : FlatButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
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
