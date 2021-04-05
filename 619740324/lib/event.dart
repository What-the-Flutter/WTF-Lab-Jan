class Event {
  String text;
  String time;
  int id;
  int noteId;
  int indexOfCircleAvatar;
  bool isSelected;

  Map<String, dynamic> insertToMap() {
    return {
      'note_id': noteId,
      'time': time,
      'text': text,
      'event_circle_avatar': indexOfCircleAvatar,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'event_id': id,
      'note_id': noteId,
      'time': time,
      'text': text,
      'event_circle_avatar': indexOfCircleAvatar,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['event_id'],
      noteId: map['note_id'],
      time: map['time'],
      text: map['text'],
      indexOfCircleAvatar: map['event_circle_avatar'],
    );
  }

  Event({
    this.noteId,
    this.id,
    this.text,
    this.time,
    this.indexOfCircleAvatar,
  });
}
