import 'dart:math';
import '../database/database.dart' as db;
import 'entities.dart' as entity;

class Task implements entity.Message {
  @override
  entity.Topic topic;

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
  static bool _firstLoad = true;
  DateTime? timeCompleted;
  static late final db.MessageLoader mLoader = db.MessageLoader.type(Task);

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
    db.MessageLoader.updateMessage(this);
  }

  void unComplete() {
    isCompleted = false;
    timeCompleted = null;
    db.MessageLoader.updateMessage(this);
  }

  @override
  int get uuid {
    _id ??= hashCode + Random.secure().nextInt(100);
    return _id!;
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': uuid,
        'type_id': entity.getTypeId(this),
        'description': description,
        'time_created': timeCreated.toString(),
        'favourite': favourite ? 1 : 0,
        'time_completed': timeCompleted.toString(),
      };

  static entity.Message fromJson(Map<String, dynamic> json, entity.Topic topic) => Task(
        id: json['id'],
        topic: topic,
        description: json['description'],
        favourite: json['favourite'] == 1 ? true : false,
        timeCreated_: DateTime.parse(json['time_created']),
        timeCompleted:
            json['time_completed'] == 'null' ? null : DateTime.parse(json['time_completed']),
      );

  static List<entity.Message> getFavouriteTasks() {
    if (_firstLoad) {
      mLoader.loadTypeFavourites();
      _firstLoad = false;
    }
    return db.MessageLoader.favouriteMessages[0];
  }

  @override
  entity.Message duplicate() {
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
