import 'data_base_contract.dart';

import 'event_message.dart';

class Suggestion implements DBContract {
  EventMessage firstEventMessage;
  EventMessage lastEventMessage;

  int id;
  String nameOfSuggestion;
  String infoOfSuggestion = 'No Events. Click to create one.';
  String imagePathOfSuggestion;
  int isPinned = 0;

  Suggestion({
    this.id,
    this.nameOfSuggestion,
    this.imagePathOfSuggestion,
    this.isPinned
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': nameOfSuggestion,
      'info': infoOfSuggestion,
      'image_path': imagePathOfSuggestion,
      'is_pinned': isPinned,
    };
  }

  Map<String, dynamic> insertToMap() {
    return {
      'name': nameOfSuggestion,
      'info': infoOfSuggestion,
      'image_path': imagePathOfSuggestion,
      'is_pinned': isPinned,
    };
  }

  factory Suggestion.fromMap(Map<String, dynamic> map) {
    return Suggestion(
      id: map['id'],
      nameOfSuggestion: map['name'],
      imagePathOfSuggestion: map['image_path'],
      isPinned: map['is_pinned'],
    );
  }
}
