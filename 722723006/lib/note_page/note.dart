class Note {
  int id;
  String noteName;
  int indexOfCircleAvatar;
  String subTittleEvent;
  String date = '';
  bool isSelected;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': noteName,
      'circle_avatar_index': indexOfCircleAvatar,
      'sub_tittle_name': subTittleEvent,
      'date': date,
      'is_selected': isSelected ? 1 : 0,
    };
  }

  Map<String, dynamic> insertToMap() {
    return {
      'name': noteName,
      'circle_avatar_index': indexOfCircleAvatar,
      'sub_tittle_name': subTittleEvent,
      'date': date,
      'is_selected': isSelected ? 1 : 0,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      noteName: map['name'],
      indexOfCircleAvatar: map['circle_avatar_index'],
      subTittleEvent: map['sub_tittle_name'],
      date: map['date'],
      isSelected: map['is_selected'] == 0 ? false : true,
    );
  }

  Note({
    this.id,
    this.noteName,
    this.subTittleEvent,
    this.indexOfCircleAvatar,
    this.date,
    this.isSelected,
  });
}
