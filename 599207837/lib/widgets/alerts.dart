import 'package:flutter/material.dart';
import '../database/database.dart';

import '../entity/entities.dart';
import '../main.dart';

class Alerts {
  static void moveAlert({
    required BuildContext context,
    required ThemeInherited themeInherited,
    required Topic currentTopic,
    required Function(Topic topic) onMoved,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: themeInherited.preset.colors.backgroundColor,
          title: Text(
            'Select the topic',
            style: TextStyle(color: themeInherited.preset.colors.textColor1),
          ),
          content: _topicList(currentTopic, themeInherited, onMoved),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 5, bottom: 5),
              child: TextButton(
                style: TextButton.styleFrom(primary: Colors.transparent),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: themeInherited.preset.colors.textColor1,
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
    ThemeInherited themeInherited,
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
                      color: themeInherited.preset.colors.textColor2,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
