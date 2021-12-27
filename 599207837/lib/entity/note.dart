import 'dart:math';

import 'entities.dart';

class Note implements Message {
  @override
  Topic topic;

  @override
  late DateTime timeCreated;

  @override
  bool favourite;

  @override
  void onFavourite() => favourite=!favourite;

  String description;
  static bool _firstLoad = true;
  static late final MessageLoader mLoader = MessageLoader.type(Note);

  Note({required this.description, required this.topic, this.favourite = false}) {
    timeCreated = DateTime.now();
  }

  int get uuid => hashCode + Random.secure().nextInt(100);

  static List<Message> getFavouriteNotes() {
    if(_firstLoad) {
      mLoader.loadTypeFavourites();
      _firstLoad = false;
    }
    return MessageLoader.favouriteMessages[2];
  }
}
