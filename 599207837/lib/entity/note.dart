import 'dart:math';
import '../database/database.dart' as db;
import 'entities.dart' as entity;

class Note implements entity.Message {
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

  static bool _firstLoad = true;
  static late final db.MessageLoader mLoader = db.MessageLoader.type(Note);

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
        'type_id': entity.getTypeId(this),
        'description': description,
        'time_created': timeCreated.toString(),
        'favourite': favourite ? 1 : 0,
      };

  static entity.Message fromJson(Map<String, dynamic> json, entity.Topic topic) => Note(
        id: json['id'],
        topic: topic,
        description: json['description'],
        favourite: json['favourite'] == 1 ? true : false,
        timeCreated_: DateTime.parse(json['time_created']),
      );

  static List<entity.Message> getFavouriteNotes() {
    if (_firstLoad) {
      mLoader.loadTypeFavourites();
      _firstLoad = false;
    }
    return db.MessageLoader.favouriteMessages[2];
  }

  @override
  entity.Message duplicate() {
    return Note(
      description: description,
      topic: topic,
      favourite: favourite,
      timeCreated_: timeCreated,
      id: _id,
    );
  }
}
