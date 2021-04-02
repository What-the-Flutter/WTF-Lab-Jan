import '../note.dart';

class StatesHomePage {
  List<Note> noteList = <Note>[];
  bool isLightTheme;

  StatesHomePage copyWith({
    List<Note> noteList,
    bool isLightTheme,
  }) {
    var state = StatesHomePage();
    state.noteList = noteList ?? this.noteList;
    state.isLightTheme = isLightTheme ?? this.isLightTheme;
    return state;
  }
}
