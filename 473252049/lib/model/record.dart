class Record {
  String message;

  bool isHighlighted = false;
  bool isFavorite;

  bool get isNotHighlighted => !isHighlighted;

  Record(this.message);
}
