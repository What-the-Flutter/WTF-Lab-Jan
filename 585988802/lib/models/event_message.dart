
class EventMessage {
  int id;
  String nameOfSuggestion;
  String time;
  String text;
  int isFavorite;
  String imagePath;
  int isImageMessage;
  String categoryImagePath;
  String nameOfCategory;

  EventMessage({
    this.id,
    this.nameOfSuggestion,
    this.time,
    this.text,
    this.isFavorite,
    this.isImageMessage,
    this.imagePath,
    this.categoryImagePath,
    this.nameOfCategory,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': nameOfSuggestion,
      'time': time,
      'text': text,
      'isFavorite': isFavorite,
      'isImageMessage': isImageMessage,
      'imagePath': imagePath,
      'categoryImagePath': categoryImagePath,
      'nameOfCategory': nameOfCategory,
    };
  }

  factory EventMessage.fromMap(Map<String, dynamic> map) => EventMessage(
        id: map['id'],
        nameOfSuggestion: map['name'],
        time: map['time'],
        text: map['text'],
        isFavorite: map['isFavorite'],
        isImageMessage: map['isImageMessage'],
        imagePath: map['imagePath'],
        categoryImagePath: map['categoryImagePath'],
        nameOfCategory: map['nameOfCategory'],
      );
}
