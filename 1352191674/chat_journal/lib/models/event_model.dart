class Event {
  String text;
  String time;
  int? id;
  int noteId;
  int? indexOfCircleAvatar;
  bool isBookmarked;
  String bookmarkCreateTime;
  String? imagePath;
  String date;
  bool isSelected;

  Event({
    required this.noteId,
    this.id,
    required this.text,
    required this.time,
    this.indexOfCircleAvatar,
    required this.isBookmarked,
    this.imagePath,
    required this.date,
    required this.isSelected,
    required this.bookmarkCreateTime,
  });

  Map<String, dynamic> insertToMap() {
    return {
      'note_id': noteId,
      'time': time,
      'text': text,
      'event_circle_avatar': indexOfCircleAvatar,
      'bookmark': isBookmarked ? 1 : 0,
      'image_path': imagePath,
      'date_format': date,
      'bookmark_create_time': bookmarkCreateTime,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'event_id': id,
      'note_id': noteId,
      'time': time,
      'text': text,
      'event_circle_avatar': indexOfCircleAvatar,
      'bookmark': isBookmarked ? 1 : 0,
      'image_path': imagePath,
      'date_format': date,
      'bookmark_create_time': bookmarkCreateTime,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['event_id'],
      noteId: map['note_id'],
      time: map['time'],
      text: map['text'],
      indexOfCircleAvatar: map['event_circle_avatar'],
      imagePath: map['image_path'],
      date: map['date_format'],
      isBookmarked: map['bookmark'] == 0 ? false : true,
      isSelected: false,
      bookmarkCreateTime: map['bookmark_create_time'],
    );
  }
}