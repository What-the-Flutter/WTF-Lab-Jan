import '../database/database.dart';

import '../properties/property_message.dart';

class MessagesRepository {
  final DBHelper dbHelper;

  MessagesRepository({
    this.dbHelper,
  });

  Future<List<PropertyMessage>> messages(int idMessagePage) async {
    return await dbHelper.dbMessagesList(idMessagePage);
  }

  Future<List<PropertyMessage>> messagesFromAllPages() async {
    return await dbHelper.dbMessagesListFromAllPages();
  }

  void addMessage(PropertyMessage message) {
    dbHelper.insertMessage(message);
  }

  void editMessage(PropertyMessage message) {
    dbHelper.updateMessage(message);
  }

  void removeMessage(int index) {
    dbHelper.deleteMessage(index);
  }
}
