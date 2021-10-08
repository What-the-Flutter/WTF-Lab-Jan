class Message {
  int? messageId;
  int currentCategoryId;
  String text;
  String time;

  Message({
    this.messageId,
    required this.currentCategoryId,
    required this.time,
    required this.text,
  });

  Map<String, dynamic> convertMessageToMap() {
    return {
      'current_category_id': currentCategoryId,
      'text': text,
      'time': time,
    };
  }

  Map<String, dynamic> convertMessageToMapWithId() {
    return {
      'message_id': messageId,
      'current_category_id': currentCategoryId,
      'text': text,
      'time': time,
    };
  }

  factory Message.fromMap(
    Map<String, dynamic> map,
  ) {
    return Message(
      messageId: map['message_id'],
      currentCategoryId: map['current_category_id'],
      text: map['text'],
      time: map['time'],
    );
  }
}
