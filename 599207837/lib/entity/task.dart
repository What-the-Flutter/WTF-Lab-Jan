import 'dart:math';
import '../database/database.dart';
import 'entities.dart';

class Task implements Message {
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

  bool isCompleted = false;
  DateTime? timeCompleted;

  Task({
    required this.topic,
    required this.description,
    this.favourite = false,
    DateTime? timeCreated_,
    this.timeCompleted,
    int? id,
  }) {
    _id = id;
    timeCreated = timeCreated_ ?? DateTime.now();
    if (timeCompleted != null) isCompleted = true;
  }

  void complete() {
    isCompleted = true;
    timeCompleted = DateTime.now();
  }

  void unComplete() {
    isCompleted = false;
    timeCompleted = null;
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
        'time_completed': timeCompleted.toString(),
      };

  static Message fromJson(Map<String, dynamic> json, Topic? topic) => Task(
        id: json['id'],
        topic: topic ?? TopicRepository.getTopicByID(json['topic_id']),
        description: json['description'],
        favourite: json['favourite'] == 1 ? true : false,
        timeCreated_: DateTime.parse(json['time_created']),
        timeCompleted:
            json['time_completed'] == 'null' ? null : DateTime.parse(json['time_completed']),
      );

  static Future<List<Message>> getFavouriteTasks() => MessageRepository.loadTypeFavourites(0);

  @override
  Message duplicate() {
    return Task(
      topic: topic,
      description: description,
      favourite: favourite,
      timeCreated_: timeCreated,
      timeCompleted: timeCompleted,
      id: _id,
    );
  }
}
