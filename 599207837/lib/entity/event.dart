import 'dart:math';
import '../database/database.dart';
import 'entities.dart';

class Event implements Message {
  @override
  Topic topic;

  @override
  late DateTime timeCreated;

  @override
  bool favourite;

  @override
  void onFavourite() => favourite = !favourite;

  @override
  String description;

  int? _id;

  DateTime? scheduledTime;
  bool isVisited;
  bool isMissed;

  Event({
    required this.topic,
    required this.description,
    this.scheduledTime,
    this.favourite = false,
    this.isVisited = false,
    this.isMissed = false,
    DateTime? timeCreated_,
    int? id,
  }) {
    _id = id;
    timeCreated = timeCreated_ ?? DateTime.now();
  }

  void visit() {
    isVisited = true;
    isMissed = false;
  }

  void unVisit() => isVisited = false;

  void miss() {
    isMissed = true;
    unVisit();
  }

  @override
  int get uuid {
    _id ??= hashCode + Random.secure().nextInt(100);
    return _id!;
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': uuid,
        'type_id': getTypeId(this),
        'topic_id': topic.id,
        'description': description,
        'time_created': timeCreated.toString(),
        'favourite': favourite ? 1 : 0,
        'scheduled_time': scheduledTime.toString(),
        'is_visited': isVisited ? 1 : 0,
        'is_missed': isMissed ? 1 : 0,
      };

  static Message fromJson(Map<String, dynamic> json, Topic? topic) => Event(
        id: json['id'],
        topic: topic ?? TopicLoader.getTopicByID(json['topic_id']),
        description: json['description'],
        favourite: json['favourite'] == 1 ? true : false,
        timeCreated_: DateTime.parse(json['time_created']),
        scheduledTime:
            json['scheduled_time'] == 'null' ? null : DateTime.parse(json['scheduled_time']),
        isVisited: json['is_visited'] == 1 ? true : false,
        isMissed: json['is_missed'] == 1 ? true : false,
      );

  static Future<List<Message>> getFavouriteEvents() => MessageLoader.loadTypeFavourites(1);

  @override
  Message duplicate() {
    return Event(
      topic: topic,
      description: description,
      scheduledTime: scheduledTime,
      favourite: favourite,
      isVisited: isVisited,
      isMissed: isMissed,
      timeCreated_: timeCreated,
      id: _id,
    );
  }
}
