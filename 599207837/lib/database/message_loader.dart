import '../entity/entities.dart' as entity;
import 'database_provider.dart';

class MessageLoader {
  static Map<int, List<entity.Message>> messages = {};
  static List<List<entity.Message>> favouriteMessages = [];

  late int _lastChecked;
  late bool _forTopic;
  late final entity.Topic _topic;
  late final Type _type;

  MessageLoader(this._topic) {
    _lastChecked = 0;
    messages[_topic.id] = [];
    _forTopic = true;
  }

  MessageLoader.type(this._type) {
    _lastChecked = 0;
    if (favouriteMessages.isEmpty) {
      favouriteMessages.addAll([[], [], []]);
    }
    _forTopic = false;
  }

  static void updateMessage(entity.Message o) async => await DBProvider.db.updateMessage(o);

  static Future<List<entity.Message>> loadElements(entity.Topic topic) async {
    if (topic.initialLoad) {
      clearElements(topic);
      messages[topic.id]!.addAll(await DBProvider.db.getLastMessages(topic));
      topic.initialLoad = false;
    }
    return messages[topic.id]!;
  }

  static void clearElements(entity.Topic topic) => messages[topic.id]!.clear();

  void loadTypeFavourites() {
    if (!_forTopic) {}
  }

  static void addToFavourites(entity.Message o) {
    favouriteMessages[entity.getTypeId(o)].insert(0, o);
  }

  static void removeFromFavourites(entity.Message o) {
    favouriteMessages[entity.getTypeId(o)].remove(o);
  }

  static void remove(entity.Message o) {
    o.topic.decContent();
    favouriteMessages[entity.getTypeId(o)].remove(o);
    messages[o.topic.id]!.remove(o);
    DBProvider.db.deleteMessage(o);
  }

  static void add(entity.Message o) {
    messages[o.topic.id]!.insert(0, o);
    o.topic.incContent();
    DBProvider.db.newMessage(o);
    if (o.favourite) {
      favouriteMessages[entity.getTypeId(o)].add(o);
    }
  }

  static void clearTopicData(int id) {
    messages[id]!.clear();
    final removed = <entity.Message>[];
    for (var list in favouriteMessages) {
      for (var item in list) {
        if (item.topic.id == id) {
          removed.add(item);
        }
      }
      for (var item in removed) {
        list.remove(item);
      }
      removed.clear();
    }
  }
}
