class Note {
  String eventName;
  String id;
  String date;
  int indexOfCircleAvatar;
  String subTittleEvent;

  Map<String, dynamic> insertToMap() {
    return {
      'id': id,
      'name': eventName,
      'circle_avatar_index': indexOfCircleAvatar,
      'sub_tittle_name': subTittleEvent,
      'date_format': date,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      eventName: map['name'],
      indexOfCircleAvatar: map['circle_avatar_index'],
      subTittleEvent: map['sub_tittle_name'],
      date: map['date_format'],
    );
  }

   Note({
    this.date = '',
    this.id = '-1',
    this.eventName = '',
    this.indexOfCircleAvatar = 0,
    this.subTittleEvent = 'Add event',
  });
}
