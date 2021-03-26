class NotePage {
  int noteId;
  String title;
  String subtitle;
  int circleAvatarIndex;

  Map<String, dynamic> convertNoteToMapWithId() {
    return {
      'note_id': noteId,
      'title': title,
      'sub_title': subtitle,
      'note_circle_avatar_index': circleAvatarIndex,
    };
  }

  Map<String, dynamic> convertNoteToMap() {
    return {
      'title': title,
      'sub_title': subtitle,
      'note_circle_avatar_index': circleAvatarIndex,
    };
  }

  factory NotePage.fromMap(Map<String, dynamic> map) {
    return NotePage(
      noteId: map['note_id'],
      title: map['title'],
      subtitle: map['sub_title'],
      circleAvatarIndex: map['note_circle_avatar_index'],
    );
  }

  NotePage({this.noteId, this.title, this.subtitle, this.circleAvatarIndex});
}
