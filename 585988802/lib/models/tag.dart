import 'data_base_contract.dart';

class Tag implements DBContract {
  int id;
  String tagText;

  Tag({
    this.id,
    this.tagText,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tag_text': tagText,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'],
      tagText: map['tag_text'],
    );
  }
}
