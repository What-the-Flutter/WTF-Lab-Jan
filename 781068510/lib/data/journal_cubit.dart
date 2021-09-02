import 'package:bloc/bloc.dart';

import '../main.dart';
import '../models/note_model.dart';

class JournalCubit extends Cubit<List<Journal>> {
  final _dataService = notes;

  JournalCubit() : super([]);

  void initJournals() => emit(notes);

  List<String> getJournalsDescriptions(int index) {
    var list = <String>[];
    for (var el in _dataService[index].note) {
      list.add(el.description);
    }
    return list;
  }

  List<Note> getJournalsNotes(int index) {
    var list = <Note>[];
    for (var el in _dataService[index].note) {
      list.add(el);
    }
    return list;
  }

  int getIndex(int index, String word) {
    for (var el in _dataService[index].note) {
      if (el.description == word) {
        return _dataService[index].note.indexOf(el);
      }
    }
    return 0;
  }

  void addJournal(Journal data) => emit(_dataService..add(data));

  void deleteJournal(int index) => emit(_dataService..removeAt(index));

  void changeJournal(Journal changed, int index) =>
      emit(_dataService..[index] = changed);

  void addEvent(Note data, int journalIndex) =>
      emit(_dataService..[journalIndex].note.add(data));

  void changeEvent(String changed, int journalIndex, int eventIndex) =>
      emit(_dataService..[journalIndex].note[eventIndex].description = changed);

  void deleteEvent(int journalIndex, int eventIndex) =>
      emit(_dataService..[journalIndex].note.removeAt(eventIndex));
}
