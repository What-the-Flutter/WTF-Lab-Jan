import 'package:flutter/material.dart';

import '../entity/entities.dart' as entity;
import '../main.dart';

class Alerts {
  static void moveAlert({
    required BuildContext context,
    required ThemeInherited themeInherited,
    required entity.Topic currentTopic,
    required Function(entity.Topic topic) onMoved,
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
    entity.Topic currentTopic,
    ThemeInherited themeInherited,
    Function onMoved,
  ) {
    final items = entity.topics.values.toList();
    return Container(
      width: 250.0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) => index == currentTopic.id
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
