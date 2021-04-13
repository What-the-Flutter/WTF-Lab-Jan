import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/db_provider.dart';
import '../../../note_page/note.dart';


import 'filter_page_state.dart';

class FilterPageCubit extends Cubit<FilterPageState> {
  FilterPageCubit(FilterPageState state) : super(state);
  final DBProvider _dbProvider = DBProvider();

  void init() async =>
      emit(state.copyWith(noteList: await _dbProvider.dbNotesList()));

  void addNote(Note note) {
    if (note.isSelected == false) {
      state.filterNotesList.add(note);
      note.isSelected = true;
    } else {
      note.isSelected = false;
      for (var i = 0; i < state.filterNotesList.length; i++) {
        if (state.filterNotesList[i].id == note.id) {
          state.filterNotesList.removeAt(i);
        }
      }
    }
    _dbProvider.updateNote(note);
    emit(state.copyWith(filterNotesList: state.filterNotesList));
  }

  void addIndexOfLabel (int indexOfLabel) {
    var isRemove = false;
    for(var i = 0; i < state.filterLabelList.length; i++){
      if(state.filterLabelList[i] == indexOfLabel){
        state.filterLabelList.remove(indexOfLabel);
        isRemove = true;
      }
    }
    if(isRemove == false) {
      state.filterLabelList.add(indexOfLabel);
    }
      emit(state.copyWith(filterLabelList: state.filterLabelList));
  }

  void deleteNote(Note note) {
    for (var i = 0; i < state.filterNotesList.length; i++) {
      if (state.filterNotesList[i].id == note.id) {
        note.isSelected = false;
        state.filterNotesList.removeAt(i);
      }
    }
    _dbProvider.updateNote(note);
    emit(state.copyWith(filterNotesList: state.filterNotesList));
  }
}
