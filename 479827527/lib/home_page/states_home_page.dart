import '../note_page.dart';

class StatesHomePage {
  List<NotePage> noteList = <NotePage>[];
  bool isLightTheme;

  StatesHomePage copyWith({
    List<NotePage> noteList,
    bool isLightTheme,
  }) {
    var state = StatesHomePage(isLightTheme ?? this.isLightTheme);
    state.noteList = noteList ?? this.noteList;
    return state;
  }

  StatesHomePage(this.isLightTheme);
}
