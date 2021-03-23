class Event {
  int eventId;
  int currentNoteId;
  String text;
  String time;
  int circleAvatarIndex;

  Event(
      {this.eventId,
      this.currentNoteId,
      this.text,
      this.time,
      this.circleAvatarIndex});

  Map<String, dynamic> convertEventToMap() {
    return {
      'current_note_id': currentNoteId,
      'text': text,
      'time': time,
      'event_circle_avatar_index': circleAvatarIndex,
    };
  }

  Map<String, dynamic> convertEventToMapWithId() {
    return {
      'event_id': eventId,
      'current_note_id': currentNoteId,
      'text': text,
      'time': time,
      'event_circle_avatar_index': circleAvatarIndex,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventId: map['event_id'],
      currentNoteId: map['current_note_id'],
      text: map['text'],
      time: map['time'],
      circleAvatarIndex: map['event_circle_avatar_index'],
    );
  }
}
