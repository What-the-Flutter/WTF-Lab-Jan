import 'package:my_project/database/database.dart';

import '../entity/entities.dart';
import 'database_provider.dart';

class MessageLoader {
  static Future<Message> lastMessage(Topic topic) => DBProvider.db.getLastMessage(topic);

  static void updateMessage(Message o) => DBProvider.db.updateMessage(o);

  static Future<List<Message>> loadElements(Topic topic) => DBProvider.db.getTopicMessages(topic);

  static Future<List<Message>> loadTypeFavourites(int typeID) =>
      DBProvider.db.getTypeFavourites(typeID);

  static void onFavourite(Message o) {
    o.onFavourite();
    updateMessage(o);
  }

  static void completeTask(Task o) {
    o.complete();
    updateMessage(o);
  }

  static void unCompleteTask(Task o) {
    o.unComplete();
    updateMessage(o);
  }

  static void visitEvent(Event o) {
    o.visit();
    updateMessage(o);
  }

  static void unVisitEvent(Event o) {
    o.unVisit();
    updateMessage(o);
  }

  static void missEvent(Event o) {
    o.miss();
    updateMessage(o);
  }

  static void remove(Message o) {
    DBProvider.db.deleteMessage(o);
    TopicLoader.decContent(o.topic);
  }

  static void add(Message o) {
    DBProvider.db.newMessage(o);
    TopicLoader.incContent(o.topic);
  }
}
