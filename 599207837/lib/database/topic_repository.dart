import 'package:flutter/cupertino.dart';

import '../entity/topic.dart';
import 'database.dart';

Map<String, Topic> _topics = {};

Map<String, Topic> get topics => _topics;

class TopicRepository {
  static void updateTopic(Topic updatedTopic) => FireBaseProvider.updateTopic(updatedTopic);

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
    FireBaseProvider.deleteTopic(topic);
  }

  static void addNewTopic(Topic topic) async {
    topics[topic.name] = topic;
    _saveNewTopic(topic);
  }

  static void _saveNewTopic(Topic topic) => FireBaseProvider.newTopic(topic);

  static Stream<List<Topic>> loadTopics() {
    FireBaseProvider.getTopics().listen((event) => _topics.clear());
    return FireBaseProvider.getTopics().map((s) {
      return s.docs.map((doc) {
        return Topic.fromJson(doc.data(), nodeID: doc.id);
      }).toList();
    });
  }

  static void incContent(Topic topic) async {
    topic.incContent();
    final message = await MessageRepository.lastMessage(topic);
    topic.lastMessage = message.timeCreated;
    updateTopic(topic);
  }

  static void decContent(Topic topic) async {
    topic.decContent();
    if (topic.elements == 0) {
      topic.lastMessage = null;
    } else {
      final message = await MessageRepository.lastMessage(topic);
      topic.lastMessage = message.timeCreated;
    }
    updateTopic(topic);
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
