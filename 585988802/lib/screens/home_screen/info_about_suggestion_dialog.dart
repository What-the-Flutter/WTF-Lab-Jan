import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/suggestion.dart';
import '../../theme/theme_bloc.dart';

class InfoAboutSuggestionDialog extends StatelessWidget {
  final Suggestion selectedSuggestion;

  const InfoAboutSuggestionDialog({Key key, this.selectedSuggestion})
      : super(key: key);

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
            color: BlocProvider.of<ThemeBloc>(context).state == ThemeMode.dark
                ? Color.fromRGBO(151, 157, 155, 1)
                : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(25.0),
          ),
          padding: EdgeInsets.only(top: 60, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                selectedSuggestion.nameOfSuggestion,
                maxLines: 6,
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 10.0,
              ),
              selectedSuggestion.firstEventMessage != null
                  ? Column(
                      children: [
                        Text(
                          'First event',
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          selectedSuggestion.firstEventMessage.time,
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
                          selectedSuggestion.lastEventMessage.time,
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
          child: Image.asset(selectedSuggestion.imagePathOfSuggestion),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ],
    );
  }
}
