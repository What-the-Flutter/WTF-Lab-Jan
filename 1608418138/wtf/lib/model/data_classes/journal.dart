import 'package:wtf/model/data_classes/message.dart';

class Journal{
  String name;
  List<Message> messages=[Message(text:'123')];
  Journal(this.name,this.messages);
  Journal.empty(this.name);

  void addMessage(Message newMessage) => messages.add(newMessage);

  void addMessages (List<Message> newMessages) => newMessages.forEach((element) =>addMessage(element));
}

