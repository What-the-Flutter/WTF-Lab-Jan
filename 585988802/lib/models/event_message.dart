import 'data_base_contract.dart';

class EventMessage implements DBContract {
  int id;
  int idOfSuggestion;
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
    this.idOfSuggestion,
    this.nameOfSuggestion,
    this.time,
    this.text,
    this.isFavorite,
    this.isImageMessage,
    this.imagePath,
    this.categoryImagePath,
    this.nameOfCategory,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_of_suggestion': idOfSuggestion,
      'name_of_suggestion': nameOfSuggestion,
      'time': time,
      'text': text,
      'is_favorite': isFavorite,
      'is_image_message': isImageMessage,
      'image_path': imagePath,
      'category_image_path': categoryImagePath,
      'name_of_category': nameOfCategory,
    };
  }

  factory EventMessage.fromMap(Map<String, dynamic> map) {
    return EventMessage(
      id: map['id'],
      idOfSuggestion: map['id_of_suggestion'],
      nameOfSuggestion: map['name_of_suggestion'],
      time: map['time'],
      text: map['text'],
      isFavorite: map['is_favorite'],
      isImageMessage: map['is_image_message'],
      imagePath: map['image_path'],
      categoryImagePath: map['category_image_path'],
      nameOfCategory: map['name_of_category'],
    );
  }
}
