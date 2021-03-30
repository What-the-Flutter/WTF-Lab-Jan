part of 'home_page_cubit.dart';

class HomePageStates {
  List<Note> noteList;
  Note note;
  HomePageStates copyWith({
    bool isThemeChange,
    List<Note> noteList,
    Note note,
  }) {
    return HomePageStates(
      noteList: noteList ?? this.noteList,
      note: note ?? this.note,
    );
  }

  HomePageStates({ this.noteList, this.note});
}
