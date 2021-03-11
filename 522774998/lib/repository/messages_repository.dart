import 'property_message.dart';

class MessagesRepository {
  final List<PropertyMessage> messages = <PropertyMessage>[];
  final List<PropertyMessage> searchingMessages = <PropertyMessage>[];

  void addSearchingMessage(PropertyMessage message) {
    searchingMessages.add(message);
  }

  void clearHistory() {
    searchingMessages.clear();
  }

  void addMessage(PropertyMessage message) {
    messages.add(message);
  }

  void editPage(int index, PropertyMessage message) {
    messages[index] = message;
  }

  void removePage(int index) {
    messages.removeAt(index);
  }
}
