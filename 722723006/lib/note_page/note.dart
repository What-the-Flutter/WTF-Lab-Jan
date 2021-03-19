class Note {
  int id;
  String noteName;
  int indexOfCircleAvatar;
  String subTittleEvent;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': noteName,
      'circle_avatar_index': indexOfCircleAvatar,
      'sub_tittle_name': subTittleEvent,
    };
  }

  Map<String, dynamic> insertToMap() {
    return {
      'name': noteName,
      'circle_avatar_index': indexOfCircleAvatar,
      'sub_tittle_name': subTittleEvent,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      noteName: map['name'],
      indexOfCircleAvatar: map['circle_avatar_index'],
      subTittleEvent: map['sub_tittle_name'],
    );
  }

  Note({this.id, this.noteName, this.subTittleEvent, this.indexOfCircleAvatar});
}
