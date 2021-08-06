enum AlignDirection { right, left }

class Note {
  final int id;
  String text;
  final DateTime created;
  DateTime? updated;
  final AlignDirection direction;

  Note(this.text, this.direction)
      : created = DateTime.now(),
        id = DateTime.now().hashCode;

  void updateText(String text) {
    this.text = text;
    updated = DateTime.now();
  }
}
