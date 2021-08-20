class Notes {
  final String title;
  List<Note>? note;
  final int iconIndex;

  Notes({required this.title, required this.iconIndex, this.note});
}

class Note {
  String time;
  bool isBookmarked;
  String description;

  Note({
    required this.time,
    required this.isBookmarked,
    required this.description,
  });
}
