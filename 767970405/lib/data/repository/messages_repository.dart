import '../data_provider.dart';

import '../model/model_message.dart';

class MessagesRepository {
  final PagesAPI api;

  MessagesRepository({
    this.api,
  });

  Future<List<ModelMessage>> messages(int pageId) async {
    var list = await api.messages(pageId);
    list.sort();
    return list;
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

  @override
  String toString() {
    return 'MessagesRepository{api: $api}';
  }
}
