import 'dart:math';
import '../database/database.dart';
import 'entities.dart';

class Note implements Message {
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

  Note({
    required this.description,
    required this.topic,
    this.favourite = false,
    DateTime? timeCreated_,
    int? id,
  }) {
    _id = id;
    timeCreated = timeCreated_ ?? DateTime.now();
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
      };

  static Message fromJson(Map<String, dynamic> json, Topic? topic) => Note(
        id: json['id'],
        topic: topic ?? TopicRepository.getTopicByID(json['topic_id']),
        description: json['description'],
        favourite: json['favourite'] == 1 ? true : false,
        timeCreated_: DateTime.parse(json['time_created']),
      );

  static Future<List<Message>> getFavouriteNotes() => MessageRepository.loadTypeFavourites(2);

  @override
  Message duplicate() {
    return Note(
      description: description,
      topic: topic,
      favourite: favourite,
      timeCreated_: timeCreated,
      id: _id,
    );
  }
}
