import 'dart:math';
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

  String description;
  DateTime? scheduledTime;
  bool _isVisited = false;
  bool _isMissed = false;
  static bool _firstLoad = true;
  static late final MessageLoader mLoader = MessageLoader.type(Event);

  Event({
    required this.topic,
    required this.description,
    this.scheduledTime,
    this.favourite = false,
  }) {
    timeCreated = DateTime.now();
  }

  void visit() {
    _isVisited = true;
    _isMissed = false;
  }

  void unVisit() => _isVisited = false;

  void miss() {
    _isMissed = true;
    unVisit();
  }

  bool isVisited() => _isVisited;

  bool isMissed() => _isMissed;

  int get uuid => hashCode + Random.secure().nextInt(100);

  static List<Message> getFavouriteEvents() {
    if (_firstLoad) {
      mLoader.loadTypeFavourites();
      _firstLoad = false;
    }
    return MessageLoader.favouriteMessages[1];
  }
}
