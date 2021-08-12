enum AlignDirection { right, left }

class Note {
  int? id;
  DateTime created;
  AlignDirection direction;
  bool hasStar;
  DateTime? updated;
  String? text;
  String? image;

  Note({
    this.id,
    required this.direction,
    this.hasStar = false,
    this.text,
    this.image,
    this.updated,
    DateTime? created,
  }) : created = created ?? DateTime.now();

  Note copyWith({bool? hasStar, String? text, String? image}) {
    return Note(
        id: id,
        direction: direction,
        hasStar: hasStar ?? this.hasStar,
        text: text ?? this.text,
        image: image ?? this.image,
        created: created,
        updated: DateTime.now());
  }

  @override
  String toString() {
    return identityHashCode(this).toString();
  }
}
