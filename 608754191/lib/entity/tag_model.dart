import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  int? id;
  String text;
  int currentCategoryId;

  Tag({
    this.id,
    required this.text,
    required this.currentCategoryId,
  });

  Map<String, dynamic> convertTagsToMap() {
    return {
      'tag_id': id,
      'tag_text': text,
      'current_category_id_from_tag': currentCategoryId,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['tag_id'],
      text: map['tag_text'],
      currentCategoryId: map['current_category_id_from_tag'],
    );
  }

  @override
  List<Object?> get props => [id, text, currentCategoryId];
}
