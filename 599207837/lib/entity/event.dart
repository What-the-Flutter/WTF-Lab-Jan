import 'dart:math';
import '../database/database.dart';
import '../main.dart';
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

  @override
  String nodeID;

  @override
  String? imageName;

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
    this.nodeID = '',
    this.imageName,
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
        'uid': userID,
        'id': uuid,
        'type_id': getTypeId(this),
        'topic_id': topic.id,
        'description': description,
        'imgPath': imageName,
        'time_created': timeCreated.toString(),
        'favourite': favourite ? 1 : 0,
        'scheduled_time': scheduledTime.toString(),
        'is_visited': isVisited ? 1 : 0,
        'is_missed': isMissed ? 1 : 0,
      };

  static Message fromJson(Map<String, dynamic> json, Topic? topic, {String nodeID = ''}) => Event(
        id: json['id'],
        nodeID: nodeID,
        topic: topic ?? TopicRepository.getTopicByID(json['topic_id']),
        description: json['description'],
        imageName: json['imgPath'] == 'null' ? null : json['imgPath'],
        favourite: json['favourite'] == 1 ? true : false,
        timeCreated_: DateTime.parse(json['time_created']),
        scheduledTime:
            json['scheduled_time'] == 'null' ? null : DateTime.parse(json['scheduled_time']),
        isVisited: json['is_visited'] == 1 ? true : false,
        isMissed: json['is_missed'] == 1 ? true : false,
      );

  static Stream<List<Message>> getFavouriteEvents() => MessageRepository.loadTypeFavourites(1);

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
