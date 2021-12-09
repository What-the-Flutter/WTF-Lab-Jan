class NoteObject {
  late final String heading;
  late String data;
  late bool isFavorite;
  bool isChecked = false;

  NoteObject({
    required this.heading,
    required this.data,
  }) {
    isFavorite = false;
  }
}
