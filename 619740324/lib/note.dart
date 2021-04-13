class Note {
  int id;
  String eventName;
  int indexOfCircleAvatar;
  String subTittleEvent;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': eventName,
      'circle_avatar_index': indexOfCircleAvatar,
      'sub_tittle_name': subTittleEvent,
    };
  }

  Map<String, dynamic> insertToMap() {
    return {
      'name': eventName,
      'circle_avatar_index': indexOfCircleAvatar,
      'sub_tittle_name': subTittleEvent,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      eventName: map['name'],
      indexOfCircleAvatar: map['circle_avatar_index'],
      subTittleEvent: map['sub_tittle_name'],
    );
  }

  Note(
      {this.id, this.eventName, this.indexOfCircleAvatar, this.subTittleEvent});
}
