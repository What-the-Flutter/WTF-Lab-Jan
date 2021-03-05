import 'property_message.dart';

class MessagesRepository {
  final List<PropertyMessage> messages = <PropertyMessage>[];

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
