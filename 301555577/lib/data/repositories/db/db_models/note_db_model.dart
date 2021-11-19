class NoteDbModel {
  final int? id;
  final int created;
  final int hasStar;
  final int? updated;
  final String? text;
  final String? image;
  final int? noteTagId;

  NoteDbModel({
    this.id,
    required this.created,
    this.hasStar = 0,
    this.updated,
    this.text,
    this.image,
    this.noteTagId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created,
      'has_star': hasStar,
      'updated': updated,
      'text': text,
      'image': image,
      'note_tag_id': noteTagId,
    };
  }

  factory NoteDbModel.fromMap(Map<String, dynamic> map) {
    return NoteDbModel(
      id: map['id'],
      created: map['created'],
      hasStar: map['has_star'],
      updated: map['updated'],
      text: map['text'],
      image: map['image'],
      noteTagId: map['note_tag_id'],
    );
  }
}
