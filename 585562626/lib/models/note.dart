enum AlignDirection { right, left }

class Note {
  final String text;
  final DateTime created;
  final AlignDirection direction;

  Note(this.text, this.direction) : created = DateTime.now();
}
