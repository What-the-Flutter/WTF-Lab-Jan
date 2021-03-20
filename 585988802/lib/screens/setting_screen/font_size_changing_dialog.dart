import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/font_size_customization.dart';

import 'setting_screen_event.dart';
import 'settings_screen_bloc.dart';

class FontSizeChangingDialog extends StatelessWidget {
  final String title, firstBtnText;
  final Icon icon;

  final List<FontSizeCustomization> _listFontSizes = [
    FontSizeCustomization(
      nameOfFontSize: 'Small',
      indexOfFontSize: 0,
    ),
    FontSizeCustomization(
      nameOfFontSize: 'Default',
      indexOfFontSize: 1,
    ),
    FontSizeCustomization(
      nameOfFontSize: 'Large',
      indexOfFontSize: 2,
    ),
  ];

  FontSizeChangingDialog({
    this.title,
    this.firstBtnText,
    this.icon,
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
          constraints: BoxConstraints(minWidth: double.infinity),
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
              Container(
                height: 300.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: _createListFontSizes(context),
                  ),
                ),
              ),
              _buttonBar(context),
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

  List<Widget> _createListFontSizes(BuildContext context) {
    var suggestionList = <Widget>[];
    for (var fontSize in _listFontSizes) {
      suggestionList.add(
        Column(
          children: <Widget>[
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              title: Text(
                fontSize.nameOfFontSize,
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              onTap: () {
                BlocProvider.of<SettingScreenBloc>(context).add(
                  ChangeFontSizeEvent(fontSize.indexOfFontSize),
                );
                Navigator.of(context).pop();
              },
            ),
            Divider(
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
      );
    }
    return suggestionList;
  }

  ButtonBar _buttonBar(BuildContext context) {
    return ButtonBar(
      buttonMinWidth: 100,
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          child: Text(
            firstBtnText,
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
