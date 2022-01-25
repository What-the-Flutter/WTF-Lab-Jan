import 'package:intl/intl.dart';

import 'event.dart';
import 'note.dart';
import 'task.dart';
import 'topic.dart';

export 'event.dart';
export 'note.dart';
export 'task.dart';
export 'theme.dart';
export 'topic.dart';

DateFormat fullDateFormatter = DateFormat('d MMM y HH:mm');
DateFormat timeFormatter = DateFormat('HH:mm');

abstract class Message {
  late Topic topic;
  late DateTime timeCreated;
  late bool favourite;
  late String description;
  late String nodeID;

  void onFavourite();

  Message duplicate();

  int get uuid;

  Map<String, dynamic> toJson();

  static Message fromJson(Map<String, dynamic> json, Topic? topic, {String nodeID = ''}) {
    switch (json['type_id']) {
      case (0):
        return Task.fromJson(json, topic, nodeID: nodeID);
      case (1):
        return Event.fromJson(json, topic, nodeID: nodeID);
      default:
        return Note.fromJson(json, topic, nodeID: nodeID);
    }
  }
}

int getTypeId(Message o) => o.runtimeType == Task ? 0 : (o.runtimeType == Event ? 1 : 2);
