import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'entities.dart' as entity;

Map<String, Topic> _topics = {};

Map<String, Topic> get topics => _topics;

class Topic {
  String name;
  String imagePath;
  late int id;
  int elements = 0;
  bool _firstLoad = true;
  late final entity.MessageLoader mLoader;

  factory Topic({required name, imagePath}) {
    if (_topics.containsKey(name)) {
      return _topics[name]!;
    } else {
      return Topic.newInstance(name: name);
    }
  }

  Topic.newInstance({required this.name, this.imagePath = '../../assets/images/topic_placeholder.jpg'}) {
    if (!_topics.containsKey(name)) {
      id = _topics.length;
      _topics[name] = this;
    } else {
      id = _topics[name]!.id;
    }
    mLoader = entity.MessageLoader(this);
  }

  ImageProvider getImageProvider() => AssetImage(imagePath);

  void incContent() => elements++;

  void decContent() => elements--;

  int get uuid => hashCode + Random.secure().nextInt(100);

  List<entity.Message> getElements() {
    if (_firstLoad) {
      mLoader.loadMessages(10);
      _firstLoad = false;
    }
    return entity.MessageLoader.messages[id];
  }

  void loadElements() {
    mLoader.loadMessages(10);
  }

  static void loadTopics() {
    entity.topics['WTF Lab'] = entity.Topic(name: 'WTF Lab');
    entity.topics['BSUIR'] = entity.Topic(name: 'BSUIR');
    entity.topics['Leisure'] = entity.Topic(name: 'Leisure');
  }

  @override
  String toString() => name;

  bool equals(Topic other) => name == other.name;
}
