import 'package:my_chat_journal/data/data_provider.dart';

import '../model/model_message.dart';

class MessagesRepository {
  final PagesAPI api;

  MessagesRepository({this.api});

  Future<List<ModelMessage>> messages(int pageId) async {
    return await api.messages(pageId);
  }

  void addMessage(ModelMessage message) async {
    api.insertMessage(message);
  }

  void editMessage(ModelMessage message) async {
   api.updateMessage(message);
  }

  void removeMessage(int index) async {
    api.deleteMessage(index);
  }
}
