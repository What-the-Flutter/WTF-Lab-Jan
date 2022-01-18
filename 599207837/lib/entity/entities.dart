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

  void onFavourite();

  Message duplicate();

  int get uuid;

  Map<String, dynamic> toJson();

  static Message fromJson(Map<String, dynamic> json, Topic topic) {
    switch (json['type_id']) {
      case (0):
        return Task.fromJson(json, topic);
      case (1):
        return Event.fromJson(json, topic);
      default:
        return Note.fromJson(json, topic);
    }
  }
}

int getTypeId(Message o) => o.runtimeType == Task ? 0 : (o.runtimeType == Event ? 1 : 2);
