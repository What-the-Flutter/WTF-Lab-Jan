class Event {
  String text;
  String time;
  String date;
  String idNote;
  String id;
  String imagePath;
  int indexOfCircleAvatar;
  int bookmarkIndex;
  bool isSelected;

  Map<String, dynamic> insertToMap() {
    return {
      'image_path': imagePath,
      'event_id': id,
      'note_id': idNote,
      'time': time,
      'text': text,
      'event_circle_avatar': indexOfCircleAvatar,
      'bookmark_index': bookmarkIndex,
      'date_format': date,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      imagePath: map['image_path'],
      id: map['event_id'],
      idNote: map['note_id'],
      time: map['time'],
      text: map['text'],
      indexOfCircleAvatar: map['event_circle_avatar'],
      bookmarkIndex: map['bookmark_index'],
      date: map['date_format'],
    );
  }

  Event({
    this.imagePath = '',
    this.idNote = '-1',
    this.id = '-1',
    this.date = '',
    this.bookmarkIndex = 0,
    this.text = '',
    this.time = '',
    this.isSelected = false,
    this.indexOfCircleAvatar = -1,
  });
}
