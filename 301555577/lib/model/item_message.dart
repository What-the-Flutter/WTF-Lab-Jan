class ItemMessage {
  String id;
  String textMessage;
  DateTime messageTime;
  bool isSelected = false;

  ItemMessage({
    required this.id,
    required this.textMessage,
    required this.messageTime,
  });
}
