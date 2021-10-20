class Message {
  int? messageId;
  int currentCategoryId;
  String text;
  String time;
  String? imagePath;

  Message({
    this.messageId,
    required this.currentCategoryId,
    required this.time,
    required this.text,
    this.imagePath,
  });

  Map<String, dynamic> convertMessageToMap() {
    return {
      'current_category_id': currentCategoryId,
      'text': text,
      'time': time,
      'image_path': imagePath,
    };
  }

  Map<String, dynamic> convertMessageToMapWithId() {
    return {
      'message_id': messageId,
      'current_category_id': currentCategoryId,
      'text': text,
      'time': time,
      'image_path': imagePath,
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
      imagePath: map['image_path'],
    );
  }
}
