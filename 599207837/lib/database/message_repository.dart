import '../entity/entities.dart';
import 'database.dart';
import 'firebase/storage_provider.dart';

class MessageRepository {
  static Future<Message> lastMessage(Topic topic) => FireBaseProvider.fetchLastMessage(topic);

  static void updateMessage(Message message) => FireBaseProvider.updateMessage(message);

  static Stream<List<Message>> loadElements(Topic topic) =>
      FireBaseProvider.fetchTopicMessages(topic).map((s) {
        return s.docs.map((doc) {
          return Message.fromJson(doc.data(), topic, nodeID: doc.id);
        }).toList();
      });

  static Stream<List<Message>> loadTypeFavourites(int typeID) =>
      FireBaseProvider.fetchTypeFavourites(typeID).map((s) {
        return s.docs.map((doc) {
          return Message.fromJson(doc.data(), null, nodeID: doc.id);
        }).toList();
      });

  static void onFavourite(Message message) {
    message.onFavourite();
    updateMessage(message);
  }

  static void completeTask(Task task) {
    task.complete();
    updateMessage(task);
  }

  static void unCompleteTask(Task task) {
    task.unComplete();
    updateMessage(task);
  }

  static void visitEvent(Event event) {
    event.visit();
    updateMessage(event);
  }

  static void unVisitEvent(Event event) {
    event.unVisit();
    updateMessage(event);
  }

  static void missEvent(Event event) {
    event.miss();
    updateMessage(event);
  }

  static void remove(Message message) {
    StorageProvider.deleteAttachedImage(message);
    FireBaseProvider.deleteMessage(message);
    TopicRepository.decContent(message.topic);
  }

  static void add(Message message) {
    FireBaseProvider.newMessage(message);
    TopicRepository.incContent(message.topic);
  }
}
