import '../entity/entities.dart';
import 'database.dart';

class MessageRepository {
  static Future<Message> lastMessage(Topic topic) => FireBaseProvider.getLastMessage(topic);

  static void updateMessage(Message o) => FireBaseProvider.updateMessage(o);

  static Stream<List<Message>> loadElements(Topic topic) =>
      FireBaseProvider.getTopicMessages(topic).map((s) {
        return s.docs.map((doc) {
          return Message.fromJson(doc.data(), topic, nodeID: doc.id);
        }).toList();
      });

  static Stream<List<Message>> loadTypeFavourites(int typeID) =>
      FireBaseProvider.loadTypeFavourites(typeID).map((s) {
        return s.docs.map((doc) {
          return Message.fromJson(doc.data(), null, nodeID: doc.id);
        }).toList();
      });

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
    FireBaseProvider.deleteMessage(o);
    TopicRepository.decContent(o.topic);
  }

  static void add(Message o) {
    FireBaseProvider.newMessage(o);
    TopicRepository.incContent(o.topic);
  }
}
