part of 'home_page_cubit.dart';

class HomePageStates {
  final List<Note> noteList;
  final Note note;
  HomePageStates copyWith({
   final bool isThemeChange,
   final List<Note> noteList,
   final Note note,
  }) {
    return HomePageStates(
      noteList: noteList ?? this.noteList,
      note: note ?? this.note,
    );
  }

  const HomePageStates({
    this.noteList,
    this.note,
  });
}
