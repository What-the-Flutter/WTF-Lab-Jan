part of 'home_page_cubit.dart';

class HomePageStates {
  List<Note> noteList;
  Note note;
  bool isThemeChange;
  HomePageStates copyWith({
    bool isThemeChange,
    List<Note> noteList,
    Note note,
  }) {
    return HomePageStates(
      noteList: noteList ?? this.noteList,
      note: note ?? this.note,
      isThemeChange: isThemeChange ?? this.isThemeChange,
    );
  }

  HomePageStates({this.isThemeChange, this.noteList, this.note});
}
