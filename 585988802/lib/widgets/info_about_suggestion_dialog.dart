import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/suggestion.dart';
import '../theme_provider/custom_theme_provider.dart';

class InfoAboutSuggestionDialog extends StatefulWidget {
  final Suggestion currentSuggestion;

  const InfoAboutSuggestionDialog({Key key, this.currentSuggestion})
      : super(key: key);

  @override
  _InfoAboutSuggestionDialogState createState() =>
      _InfoAboutSuggestionDialogState(currentSuggestion);
}

class _InfoAboutSuggestionDialogState extends State<InfoAboutSuggestionDialog> {
  final Suggestion currentSuggestions;

  _InfoAboutSuggestionDialogState(this.currentSuggestions);

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
                currentSuggestions.nameOfSuggestion,
                maxLines: 6,
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 10.0,
              ),
              currentSuggestions.eventMessagesList.isNotEmpty
                  ? Column(
                      children: [
                        Text(
                          'First event',
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          currentSuggestions.eventMessagesList.last.time,
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Latest event',
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          currentSuggestions.eventMessagesList.first.time,
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Text(
                      'No events',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
              SizedBox(
                height: 10.0,
              ),
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
        CircleAvatar(
          maxRadius: 40.0,
          child: Image.asset(currentSuggestions.imagePathOfSuggestion),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ],
    );
  }
}
