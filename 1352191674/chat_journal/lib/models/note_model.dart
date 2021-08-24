class Note {
  int id;
  String noteName;
  int indexOfCircleAvatar;
  String subTitleEvent;
  String date = '';
  bool isSelected;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': noteName,
      'circle_avatar_index': indexOfCircleAvatar,
      'sub_tittle_name': subTitleEvent,
      'date': date,
      'is_selected': isSelected ? 1 : 0,
    };
  }

  Map<String, dynamic> insertToMap() {
    return {
      'name': noteName,
      'circle_avatar_index': indexOfCircleAvatar,
      'sub_tittle_name': subTitleEvent,
      'date': date,
      'is_selected': isSelected ? 1 : 0,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      noteName: map['name'],
      indexOfCircleAvatar: map['circle_avatar_index'],
      subTitleEvent: map['sub_tittle_name'],
      date: map['date'],
      isSelected: map['is_selected'] == 0 ? false : true,
    );
  }

  Note({
    required this.id,
    required this.noteName,
    required this.subTitleEvent,
    required this.indexOfCircleAvatar,
    required this.date,
    required this.isSelected,
  });
}