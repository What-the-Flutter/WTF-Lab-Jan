part of 'home_page_cubit.dart';

class HomePageStates {
  bool isThemeChange = false;
  List<Note> noteList;

  HomePageStates copyWith({
    bool isThemeChange,
    List<Note> noteList,
  }) {
    var state = HomePageStates(noteList ?? this.noteList);
    state.isThemeChange = isThemeChange ?? this.isThemeChange;
    return state;
  }

  HomePageStates(this.noteList);
}
