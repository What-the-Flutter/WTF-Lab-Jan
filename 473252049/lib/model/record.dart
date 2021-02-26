class Record {
  String message;

  bool isSelected = false;
  bool isFavorite = false;

  Record(this.message);

  void select() => isSelected = true;
  void unselect() => isSelected = false;

  void favorite() => isFavorite = true;
  void unfavorite() => isFavorite = false;

  @override
  String toString() {
    return message;
  }
}
