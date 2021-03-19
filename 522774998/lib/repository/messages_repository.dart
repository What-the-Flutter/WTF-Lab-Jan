import '../database/database.dart';

import 'property_message.dart';

class MessagesRepository {
  List<PropertyMessage> messages = <PropertyMessage>[];
  final List<PropertyMessage> searchingMessages = <PropertyMessage>[];
  final DBHelper _dbHelper = DBHelper();

  void addSearchingMessage(PropertyMessage message) {
    searchingMessages.add(message);
  }

  void setAllMessages(int index) async {
    var dbMessageList = await _dbHelper.dbMessagesList(index);
    messages = dbMessageList;
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
