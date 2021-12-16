import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'entities.dart' as entity;

Map<String, Topic> _topics = {};

Map<String, Topic> get topics => _topics;

class Topic {
  String name;
  String imagePath;
  int elements = 0;

  Topic({
    required this.name,
    this.imagePath = '../../assets/images/topic_placeholder.jpg',
  }) {
    if (!_topics.containsKey(name)) {
      _topics[name] = this;
    }
    _topics[name]!.incContent();
  }

  ImageProvider getImageProvider() => AssetImage(imagePath);

  void incContent() => elements++;

  void decContent() => elements--;

  int get uuid => hashCode + Random.secure().nextInt(100);

  List<entity.Message> getElements() {
    var ret = (entity.Task.getPendingTasksM()
        .where((element) => element.topic.equals(this))).toList();
    ret += entity.Event.getUpcomingEventsM()
        .where((element) => element.topic.equals(this))
        .toList();
    ret += entity.Note.getNotesM()
        .where((element) => element.topic.equals(this))
        .toList();
    return ret;
  }

  @override
  String toString() => name;

  bool equals(Topic other) => name == other.name;
}
