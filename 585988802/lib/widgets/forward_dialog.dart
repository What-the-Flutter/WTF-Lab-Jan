import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/list_view_suggestion.dart';

class ForwardDialog extends StatefulWidget {
  final String title, firstBtnText, secondBtnText;
  final Icon icon;
  final dynamic firstBtnFunc, secondBtnFunc;
  final List<ListViewSuggestion> suggestionsList;

  ForwardDialog({
    this.title,
    this.firstBtnText,
    this.secondBtnText,
    this.icon,
    this.firstBtnFunc,
    this.secondBtnFunc,
    this.suggestionsList,
  });

  @override
  _CustomDialog createState() => _CustomDialog(
        title,
        firstBtnText,
        secondBtnText,
        icon,
        firstBtnFunc,
        secondBtnFunc,
        suggestionsList,
      );
}

class _CustomDialog extends State<ForwardDialog> {
  final String title, firstBtnText, secondBtnText;
  final Icon icon;
  final dynamic firstBtnFunc, secondBtnFunc;
  final List<ListViewSuggestion> suggestionsList;

  _CustomDialog(
    this.title,
    this.firstBtnText,
    this.secondBtnText,
    this.icon,
    this.firstBtnFunc,
    this.secondBtnFunc,
    this.suggestionsList,
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  List<ListViewSuggestion> _suggestionsList;
  ListViewSuggestion selectedListViewSuggestion;

  @override
  void initState() {
    super.initState();
    _suggestionsList = suggestionsList;
  }

  void _setSelectedSuggestion(ListViewSuggestion listViewSuggestion) {
    setState(() {
      selectedListViewSuggestion = listViewSuggestion;
    });
  }

  List<Widget> createRadioListSuggestion() {
    var suggestionList = <Widget>[];
    for (var listViewSuggestion in _suggestionsList) {
      suggestionList.add(
        RadioListTile(
          value: listViewSuggestion,
          groupValue: selectedListViewSuggestion,
          title: Text(listViewSuggestion.nameOfSuggestion),
          onChanged: (currentSuggestion) {
            _setSelectedSuggestion(currentSuggestion);
          },
          selected: selectedListViewSuggestion == listViewSuggestion,
          activeColor: Colors.redAccent,
        ),
      );
    }
    return suggestionList;
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
                    children: createRadioListSuggestion(),
                  ),
                ),
              ),
              _buttonBar,
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

  ButtonBar get _buttonBar {
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
            firstBtnFunc();
            Navigator.of(context).pop();
          },
        ),
        selectedListViewSuggestion == null
            ? Container()
            : TextButton(
                child: Text(
                  secondBtnText,
                  style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
                onPressed: () {
                  secondBtnFunc(selectedListViewSuggestion);
                  Navigator.of(context).pop();
                },
              ),
      ],
    );
  }
}
