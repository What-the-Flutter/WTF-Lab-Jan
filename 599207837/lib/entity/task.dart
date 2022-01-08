import 'dart:math';
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

  bool isCompleted = false;
  static bool _firstLoad = true;
  DateTime? timeCompleted;
  static late final MessageLoader mLoader = MessageLoader.type(Task);

  Task({required this.topic, required this.description, this.favourite = false}) {
    timeCreated = DateTime.now();
  }

  void complete() => isCompleted = true;

  void unComplete() => isCompleted = false;

  @override
  int get uuid => hashCode + Random.secure().nextInt(100);

  static List<Message> getFavouriteTasks() {
    if (_firstLoad) {
      mLoader.loadTypeFavourites();
      _firstLoad = false;
    }
    return MessageLoader.favouriteMessages[0];
  }
}
