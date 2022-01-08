import 'dart:math';

import 'package:flutter/material.dart';
import 'entities.dart' as entity;

Map<String, Topic> _topics = {};

Map<String, Topic> get topics => _topics;

class Topic {
  static int _vacantIndex = 0;
  static List<Topic> topics = [];
  String name;
  IconData icon;
  late int id;
  late DateTime timeCreated;
  int elements = 0;
  bool _firstLoad = true;
  late bool _pinned;
  late bool _archived;
  late final entity.MessageLoader mLoader;

  void onPin() => _pinned = !_pinned;

  void onArchive() {
    _archived = !_archived;
    entity.MessageLoader.clearTopicData(id);
  }

  bool get isPinned => _pinned;

  bool get isArchived => _archived;

  factory Topic({required String name, required IconData icon}) {
    if (_topics.containsKey(name)) {
      return _topics[name]!;
    } else {
      return Topic.newInstance(
        name: name,
        icon: icon,
      );
    }
  }

  Topic.newInstance({
    required this.name,
    required this.icon,
    bool pinned = false,
    bool archived = false,
  }) {
    _archived = archived;
    _pinned = pinned;
    id = _vacantIndex;
    timeCreated = DateTime.now();
    _vacantIndex++;
    _topics[name] = this;
    mLoader = entity.MessageLoader(this);
  }

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
    if(topics.isEmpty){
      topics.add(entity.Topic(name: 'WTF Lab', icon: Icons.flutter_dash_rounded));
      topics.add(entity.Topic(name: 'BSUIR', icon: Icons.account_balance_rounded));
      topics.add(entity.Topic(name: 'Leisure', icon: Icons.sports_esports_rounded));
    }
  }

  void delete() {
    entity.MessageLoader.clearTopicData(id);
    _topics.remove(name);
    topics.remove(this);
  }

  @override
  String toString() => name;

  bool equals(Topic other) => name == other.name;
}
