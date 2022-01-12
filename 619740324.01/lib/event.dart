class Event {
  String text;
  String time;
  String date;
  int id;
  int noteId;
  int indexOfCircleAvatar;
  int bookmarkIndex;
  bool isSelected;

  Map<String, dynamic> insertToMap() {
    return {
      'note_id': noteId,
      'time': time,
      'text': text,
      'event_circle_avatar': indexOfCircleAvatar,
      'bookmark_index': bookmarkIndex,
      'date_format': date,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'event_id': id,
      'note_id': noteId,
      'time': time,
      'text': text,
      'event_circle_avatar': indexOfCircleAvatar,
      'bookmark_index': bookmarkIndex,
      'date_format': date,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['event_id'],
      noteId: map['note_id'],
      time: map['time'],
      text: map['text'],
      indexOfCircleAvatar: map['event_circle_avatar'],
      bookmarkIndex: map['bookmark_index'],
      date: map['date_format'],
    );
  }


  Event({
    this.noteId = -1,
    this.id = -1,
    this.date = '',
    this.bookmarkIndex = 0,
    this.text = '',
    this.time = '',
    this.isSelected = false,
    this.indexOfCircleAvatar = -1,
  });
}
