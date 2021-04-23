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

  Future<int> addMessage(ModelMessage message) {
    return api.insertMessage(message);
  }

  void editMessage(ModelMessage message) {
    api.updateMessage(message);
  }

  void removeMessage(int index) {
    api.deleteMessage(index);
  }

  Future<List<ModelTag>> tags() {
    return api.tags();
  }

  Future<int> addTag(ModelTag tag) {
    return api.insertTag(tag);
  }
}
