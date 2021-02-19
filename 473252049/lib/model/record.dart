class Record {
  String message;

  bool isHighlighted = false;
  bool isFavorite = false;

  Record(this.message);

  bool get isNotHighlighted => !isHighlighted;
  bool get isNotFavorite => !isFavorite;

  void changeIsFavorite() {
    isFavorite = !isFavorite;
  }
}
