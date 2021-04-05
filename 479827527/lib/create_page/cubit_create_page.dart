import 'package:flutter_bloc/flutter_bloc.dart';
import '../note.dart';
import '../utils/database.dart';
import 'states_create_page.dart';

class CubitCreatePage extends Cubit<StatesCreatePage> {
  CubitCreatePage() : super(StatesCreatePage());
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init(){
    setSelectedIconIndex(0);
  }

  void setSelectedIconIndex(int selectedIconIndex) =>
      emit(state.updateSelectedIconIndex(selectedIconIndex));

  void editPage(Note note) => _databaseProvider.updateNote(note);

  void addPage(Note note) async =>
      note.noteId = await _databaseProvider.insertNote(note);
}
