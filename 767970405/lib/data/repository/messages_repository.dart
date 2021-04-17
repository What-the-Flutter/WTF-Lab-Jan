import '../data_provider.dart';
import '../model/model_message.dart';
import '../model/model_tag.dart';

class MessagesRepository {
  final PagesAPI api;

  MessagesRepository({
    this.api,
  });

  Future<List<ModelMessage>> messages([int pageId]) async {
    var list =
        pageId != null ? await api.messages(pageId) : await api.messages();
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

  Future<List<ModelTag>> tags() async {
    return await api.tags();
  }

  void addTag(ModelTag tag) async {
    api.insertTag(tag);
  }
}
