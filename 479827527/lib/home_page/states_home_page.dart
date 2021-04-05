import '../note.dart';

class StatesHomePage {
  final List<Note> noteList;
  final bool isLightTheme;

  const StatesHomePage({this.noteList, this.isLightTheme});

  StatesHomePage copyWith({
    final List<Note> noteList,
    final bool isLightTheme,
  }) {
    return StatesHomePage(
      noteList: noteList ?? this.noteList,
      isLightTheme: isLightTheme ?? this.isLightTheme,
    );
  }
}
