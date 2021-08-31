part of 'home_page_cubit.dart';

class HomePageState {
  final List<Note> noteList;
  final Note? note;

  HomePageState copyWith({
    bool? isThemeChange,
    List<Note>? noteList,
    Note? note,
  }) {
    return HomePageState(
      noteList ?? this.noteList,
      note ?? this.note,
    );
  }

  const HomePageState(
    this.noteList,
    this.note,
  );
}
