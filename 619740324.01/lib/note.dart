class Note {
  String eventName;
  String id;
  int indexOfCircleAvatar;
  String subTittleEvent;

  Map<String, dynamic> insertToMap() {
    return {
      'id': id,
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

  Note({
    this.id = '-1',
    this.eventName = '',
    this.indexOfCircleAvatar = 0,
    this.subTittleEvent = 'Add event',
  });
}
