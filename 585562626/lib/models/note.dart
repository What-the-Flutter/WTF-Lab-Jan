enum AlignDirection { right, left }

class BaseNote {
  int id;
  DateTime created;
  AlignDirection direction;

  BaseNote(this.direction)
      : id = DateTime.now().hashCode,
        created = DateTime.now();
}

class TextNote extends BaseNote {
  DateTime? updated;
  String text;

  TextNote(this.text, AlignDirection direction) : super(direction);

  void updateText(String text) {
    this.text = text;
    updated = DateTime.now();
  }
}

class ImageNote extends BaseNote {
  String image;

  ImageNote(this.image, AlignDirection direction) : super(direction);
}
