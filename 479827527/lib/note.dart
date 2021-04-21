class Note {
  int noteId;
  String title;
  String subtitle;
  int circleAvatarIndex;
  String date;

  Note({
    this.noteId,
    this.title,
    this.subtitle,
    this.circleAvatarIndex,
    this.date,
  });

  Map<String, dynamic> convertNoteToMapWithId() {
    return {
      'note_id': noteId,
      'title': title,
      'sub_title': subtitle,
      'note_circle_avatar_index': circleAvatarIndex,
      'date': date,
    };
  }

  Map<String, dynamic> convertNoteToMap() {
    return {
      'title': title,
      'sub_title': subtitle,
      'note_circle_avatar_index': circleAvatarIndex,
      'date': date,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      noteId: map['note_id'],
      title: map['title'],
      subtitle: map['sub_title'],
      circleAvatarIndex: map['note_circle_avatar_index'],
      date: map['date'],
    );
  }
}
