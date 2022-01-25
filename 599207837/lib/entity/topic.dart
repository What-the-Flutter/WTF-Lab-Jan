import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import '../database/database.dart';

Topic topicFromJson(String str) {
  final jsonData = json.decode(str);
  return Topic.fromJson(jsonData);
}

String topicToJson(Topic data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Topic {
  String name;
  String nodeID;
  IconData icon;
  late int id;
  late DateTime timeCreated;
  DateTime? lastMessage;
  int elements;
  late bool _pinned;
  late bool _archived;

  void onPin() => _pinned = !_pinned;

  void onArchive() => _archived = !_archived;

  bool get isPinned => _pinned;

  bool get isArchived => _archived;

  factory Topic({required String name, required IconData icon}) {
    if (topics.containsKey(name)) {
      return topics[name]!;
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
    this.nodeID = '',
    bool pinned = false,
    bool archived = false,
    int? id_,
    this.elements = 0,
    DateTime? timeCreated_,
    this.lastMessage,
  }) {
    _archived = archived;
    _pinned = pinned;
    id = id_ ?? hashCode + Random.secure().nextInt(100);
    timeCreated = timeCreated_ ?? DateTime.now();
    topics[name] = this;
  }

  factory Topic.fromJson(Map<String, dynamic> json, {String nodeID = ''}) => Topic.newInstance(
        id_: json['id'],
        name: json['name'],
        nodeID: nodeID,
        icon: IconData(json['icon_data'] as int, fontFamily: 'MaterialIcons'),
        elements: json['elements'],
        pinned: json['pinned'] == 1 ? true : false,
        archived: json['archived'] == 1 ? true : false,
        timeCreated_: DateTime.parse(json['time_created']),
        lastMessage: json['last_message'] == 'null' ? null : DateTime.parse(json['last_message']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon_data': icon.codePoint,
        'elements': elements,
        'pinned': _pinned ? 1 : 0,
        'archived': _archived ? 1 : 0,
        'time_created': timeCreated.toString(),
        'last_message': lastMessage.toString(),
      };

  void incContent() => elements++;

  void decContent() => elements--;

  @override
  String toString() => name;

  bool equals(Topic other) => name == other.name;
}
