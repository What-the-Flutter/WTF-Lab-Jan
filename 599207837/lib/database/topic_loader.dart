import 'package:flutter/cupertino.dart';

import '../entity/topic.dart';
import 'database_provider.dart';
import 'message_loader.dart';

Map<String, Topic> _topics = {};

Map<String, Topic> get topics => _topics;

class TopicLoader {
  static void updateTopic(Topic updatedTopic) async =>
      await DBProvider.db.updateTopic(updatedTopic);

  static void editTopic(Topic topic, String newName, IconData newIcon) {
    if (topic.name != newName) {
      topics.remove(topic.name);
      topic.name = newName;
      topics[topic.name] = topic;
    }
    if (topic.icon != newIcon) topic.icon = newIcon;
    updateTopic(topic);
  }

  static Topic getTopicByID(int id) => _topics.values.where((element) => element.id == id).single;

  static void deleteTopic(Topic topic) {
    topics.remove(topic.name);
    DBProvider.db.deleteTopic(topic);
  }

  static void addNewTopic(Topic topic) async {
    topics[topic.name] = topic;
    _saveNewTopic(topic);
  }

  static void _saveNewTopic(Topic topic) async => await DBProvider.db.newTopic(topic);

  static Future<List<Topic>> loadTopics() async => await DBProvider.db.getAllTopics();

  static void incContent(Topic topic) async {
    topic.incContent();
    updateTopic(topic);
    final message = await MessageLoader.lastMessage(topic);
    topic.lastMessage = message.timeCreated;
  }

  static void decContent(Topic topic) async {
    topic.decContent();
    updateTopic(topic);
    if (topic.elements == 0) {
      topic.lastMessage = null;
    } else {
      final message = await MessageLoader.lastMessage(topic);
      topic.lastMessage = message.timeCreated;
    }
  }

  static List<Topic> getTopics() {
    return topics.values.toList()
      ..sort((a, b) {
        if (a.lastMessage == null && b.lastMessage == null) {
          return b.timeCreated.compareTo(a.timeCreated);
        } else if (a.lastMessage == null) {
          return 1;
        } else if (b.lastMessage == null) {
          return -1;
        } else {
          return b.lastMessage!.compareTo(a.lastMessage!);
        }
      });
  }
}
