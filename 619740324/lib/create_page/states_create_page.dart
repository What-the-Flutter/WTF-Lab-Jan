import '../note.dart';

class StatesCreatePage {
  int indexOfSelectedIcon;
  List<Note> noteList;

  StatesCreatePage(this.indexOfSelectedIcon, this.noteList);

  StatesCreatePage copyWith({
    List<Note> noteList,
    int indexOfSelectedIcon,
  }) {
    return StatesCreatePage(indexOfSelectedIcon ?? this.indexOfSelectedIcon,
        noteList ?? this.noteList);
  }
}
