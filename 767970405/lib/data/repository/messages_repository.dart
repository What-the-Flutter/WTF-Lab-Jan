import '../model/model_message.dart';

class MessagesRepository {
  final List<ModelMessage> messages = <ModelMessage>[];

  void addMessage(ModelMessage message) {
    messages.add(message);
  }

  void editPage(int index, ModelMessage message) {
    messages[index] = message;
  }

  void removePage(int index) {
    messages.removeAt(index);
  }
}
