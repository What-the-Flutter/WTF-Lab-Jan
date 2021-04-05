import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/database_provider.dart';
import '../note.dart';
import 'states_create_page.dart';

class CubitCreatePage extends Cubit<StatesCreatePage> {
  CubitCreatePage(StatesCreatePage state) : super(state);
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void addNote(String text) async {
    if (text.isNotEmpty) {
      var note = Note(
        eventName: text,
        subTittleEvent: '',
        indexOfCircleAvatar: state.indexOfSelectedIcon,
      );
      state.noteList.insert(0, note);
      note.id = await _databaseProvider.insertNote(note);
      emit(state.copyWith(noteList: state.noteList));
    }
  }

  void setIndexOfIcon(int indexOfSelectedIcon) =>
      emit(state.copyWith(indexOfSelectedIcon: indexOfSelectedIcon));
}
