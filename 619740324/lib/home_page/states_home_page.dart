import '../note.dart';

class StatesHomePage {
  bool isLightTheme = true;
  List<Note> noteList;
  Note note;

  StatesHomePage({this.noteList, this.note, this.isLightTheme});

  StatesHomePage copyWith(
      {bool themeSwitcher, List<Note> noteList, bool isLightTheme, Note note}) {
    return StatesHomePage(
      noteList: noteList ?? this.noteList,
      note: note ?? this.note,
      isLightTheme: isLightTheme ?? this.isLightTheme,
    );
  }
}
