class Message {
  int? messageId;
  int currentCategoryId;
  String text;
  String time;
  int? bookmarkIndex;
  String? imagePath;

  Message({
    this.messageId,
    required this.currentCategoryId,
    required this.time,
    required this.text,
    this.imagePath,
    this.bookmarkIndex,
  });

  Map<String, dynamic> convertMessageToMap() {
    return {
      'current_category_id': currentCategoryId,
      'text': text,
      'time': time,
      'image_path': imagePath,
      'bookmark_index': bookmarkIndex,
    };
  }

  Map<String, dynamic> convertMessageToMapWithId() {
    return {
      'message_id': messageId,
      'current_category_id': currentCategoryId,
      'text': text,
      'time': time,
      'image_path': imagePath,
      'bookmark_index': bookmarkIndex,
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
      bookmarkIndex: map['bookmark_index'],
    );
  }
}
