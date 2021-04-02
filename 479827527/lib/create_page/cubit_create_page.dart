import 'package:flutter_bloc/flutter_bloc.dart';
import '../note.dart';
import '../utils/database.dart';
import 'states_create_page.dart';

class CubitCreatePage extends Cubit<StatesCreatePage> {
  CubitCreatePage(StatesCreatePage state) : super(state);
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void setSelectedIconIndex(int selectedIconIndex) =>
      emit(state.updateIndex(selectedIconIndex));

  void editPage(Note note) => _databaseProvider.updateNote(note);

  void addPage(Note note) async =>
      note.noteId = await _databaseProvider.insertNote(note);
}
