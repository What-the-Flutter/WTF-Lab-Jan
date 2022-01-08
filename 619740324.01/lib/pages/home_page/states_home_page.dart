import '../../note.dart';

class StatesHomePage {
  final List<Note> noteList;
  final Note? note;

  StatesHomePage({this.noteList = const [], this.note});

  StatesHomePage copyWith({
    List<Note>? noteList,
    Note? note,
  }) {
    return StatesHomePage(
      noteList: noteList ?? this.noteList,
      note: note ?? this.note,
    );
  }
}
