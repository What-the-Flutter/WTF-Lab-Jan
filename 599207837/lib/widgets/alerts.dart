import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/database.dart';
import '../entity/entities.dart';
import 'theme_provider/theme_cubit.dart';
import 'theme_provider/theme_state.dart';

class Alerts {
  static void moveAlert({
    required BuildContext context,
    required Topic currentTopic,
    required Function(Topic topic) onMoved,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = context.read<ThemeCubit>().state;
        return AlertDialog(
          backgroundColor: theme.colors.backgroundColor,
          title: Text(
            'Select the topic',
            style: TextStyle(color: theme.colors.textColor1),
          ),
          content: _topicList(currentTopic, theme, onMoved),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 5, bottom: 5),
              child: TextButton(
                style: TextButton.styleFrom(primary: Colors.transparent),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.colors.textColor1,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _topicList(
    Topic currentTopic,
    ThemeState theme,
    Function onMoved,
  ) {
    final items = topics.values.toList();
    return Container(
      width: 250.0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) => items[index].id == currentTopic.id
            ? Container()
            : GestureDetector(
                onTap: () => onMoved(items[index]),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    items[index].name,
                    style: TextStyle(
                      color: theme.colors.textColor2,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
