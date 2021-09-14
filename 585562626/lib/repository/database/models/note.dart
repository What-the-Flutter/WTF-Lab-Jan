class DbNote {
  final int? id;
  final int created;
  final int direction;
  final int hasStar;
  final int? updated;
  final String? text;
  final String? image;

  DbNote({
    this.id,
    required this.created,
    required this.direction,
    this.hasStar = 0,
    this.updated,
    this.text,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created,
      'direction': direction,
      'hasStar': hasStar,
      'updated': updated,
      'text': text,
      'image': image,
    };
  }

  factory DbNote.fromMap(Map<String, dynamic> map) {
    return DbNote(
      id: map['id'],
      created: map['created'],
      direction: map['direction'],
      hasStar: map['hasStar'],
      updated: map['updated'],
      text: map['text'],
      image: map['image'],
    );
  }
}
