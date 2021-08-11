import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/note.dart';
import '../../../repository/note_repository.dart';
import 'category_notes_event.dart';
import 'category_notes_state.dart';

class CategoryNotesBloc extends Bloc<CategoryNotesEvent, CategoryNotesState> {
  final NoteRepository noteRepository;

  CategoryNotesBloc(CategoryNotesState initialState, {required this.noteRepository, required})
      : super(initialState);

  @override
  Stream<CategoryNotesState> mapEventToState(CategoryNotesEvent event) async* {
    if (event is FetchNotesEvent) {
      yield await _fetchNotes();
    } else if (event is SwitchStarEvent) {
      await noteRepository.switchStar(state.selectedNotes);
      yield await _fetchNotes();
    } else if (event is SwitchEditingModeEvent) {
      yield state.copyWith(
        isEditingMode: !state.isEditingMode,
        selectedNotes: [],
        startedUpdating: false,
      );
    } else if (event is AddNoteEvent) {
      if (state.image != null) {
        noteRepository.addNote(state.category.id, ImageNote(state.image!.path, event.direction));
      }
      if (state.text != null) {
        noteRepository.addNote(state.category.id, TextNote(state.text!, event.direction));
      }
      final newState = await _fetchNotes();
      yield newState.copyWith(text: '');
    } else if (event is SwitchNoteSelectionEvent) {
      final selectedNotes = state.selectedNotes.toList();
      print('BEFORE $selectedNotes');
      if (selectedNotes.contains(event.note)) {
        selectedNotes.remove(event.note);
      } else {
        selectedNotes.add(event.note);
      }
      print('AFTER $selectedNotes');
      yield state.copyWith(selectedNotes: selectedNotes);
    } else if (event is DeleteSelectedNotesEvent) {
      await noteRepository.deleteNotes(state.selectedNotes);
      final newState = await _fetchNotes();
      yield newState.copyWith(selectedNotes: [], isEditingMode: false, startedUpdating: false);
    } else if (event is StartEditingEvent) {
      yield state.copyWith(
        startedUpdating: true,
        text: (state.selectedNotes.first as TextNote?)?.text ?? state.text,
        showImagePicker: (state.selectedNotes.first is ImageNote),
      );
    } else if (event is UpdateNoteEvent) {
      yield state.copyWith(isEditingMode: false, selectedNotes: []);
    } else if (event is ImageSelectedEvent) {
      yield state.copyWith(image: event.image, showImagePicker: false);
    } else if (event is ImagePickerClosedEvent) {
      yield state.copyWith(showImagePicker: false);
    } else if (event is TextChangedEvent) {
      yield state.copyWith(text: event.text);
    }
  }

  Future<CategoryNotesState> _fetchNotes() async {
    final notes = await noteRepository.fetchNotes(state.category);
    return state.copyWith(notes: notes);
  }
}
