import 'event_message.dart';

class Suggestion {
  List<EventMessage> eventMessagesList = <EventMessage>[];

  int id;
  String nameOfSuggestion;
  String infoOfSuggestion = 'No Events. Click to create one.';
  String imagePathOfSuggestion;
  int isPinned = 0;

  Suggestion({
    this.id,
    this.nameOfSuggestion,
    this.imagePathOfSuggestion,
    this.isPinned,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': nameOfSuggestion,
      'info': infoOfSuggestion,
      'imagePath': imagePathOfSuggestion,
      'isPinned': isPinned,
    };
  }

  factory Suggestion.fromMap(Map<String, dynamic> map) => Suggestion(
        id: map['id'],
        nameOfSuggestion: map['name'],
        imagePathOfSuggestion: map['imagePath'],
        isPinned: map['isPinned'],
      );
}
