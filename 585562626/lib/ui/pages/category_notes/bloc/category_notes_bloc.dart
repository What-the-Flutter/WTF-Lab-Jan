import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/note.dart';
import '../../../../repository/note_repository.dart';
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
      yield await _switchStar();
    } else if (event is SwitchEditingModeEvent) {
      yield _switchEditingMode();
    } else if (event is AddNoteEvent) {
      yield await _addNote(event);
    } else if (event is SwitchNoteSelectionEvent) {
      yield _switchNoteSelection(event);
    } else if (event is DeleteSelectedNotesEvent) {
      yield await _deleteNotes();
    } else if (event is StartEditingEvent) {
      yield _startEditing();
    } else if (event is UpdateNoteEvent) {
      yield await _updateNote();
    } else if (event is ImageSelectedEvent) {
      yield state.copyWith(image: event.image, showImagePicker: false);
    } else if (event is ImagePickerClosedEvent) {
      yield state.copyWith(showImagePicker: false);
    } else if (event is TextChangedEvent) {
      yield state.copyWith(text: event.text);
    }
  }

  Future<CategoryNotesState> _switchStar() async {
    await noteRepository.switchStar(state.selectedNotes);
    return await _fetchNotes();
  }

  CategoryNotesState _switchEditingMode() {
    return state.copyWith(
      isEditingMode: !state.isEditingMode,
      selectedNotes: [],
      startedUpdating: false,
      text: '',
    );
  }

  Future<CategoryNotesState> _addNote(AddNoteEvent event) async {
    if (state.category.id != null) {
      await noteRepository.addNote(
        state.category.id!,
        Note(image: state.image?.path, text: state.text, direction: event.direction),
      );
    }
    final newState = await _fetchNotes();
    return newState.resetImage().copyWith(text: '');
  }

  CategoryNotesState _switchNoteSelection(SwitchNoteSelectionEvent event) {
    final selectedNotes = state.selectedNotes.toList();
    if (selectedNotes.contains(event.note)) {
      selectedNotes.remove(event.note);
    } else {
      selectedNotes.add(event.note);
    }
    return state.copyWith(selectedNotes: selectedNotes);
  }

  Future<CategoryNotesState> _deleteNotes() async {
    await noteRepository.deleteNotes(state.selectedNotes);
    final newState = await _fetchNotes();
    return newState.copyWith(selectedNotes: [], isEditingMode: false, startedUpdating: false);
  }

  CategoryNotesState _startEditing() {
    return state.copyWith(
      startedUpdating: true,
      text: state.selectedNotes.first.text ?? state.text,
      showImagePicker: state.selectedNotes.first.image != null,
    );
  }

  Future<CategoryNotesState> _updateNote() async {
    final note = state.selectedNotes.first.copyWith(text: state.text, image: state.image?.path);
    await noteRepository.updateNote(note);
    final newState = await _fetchNotes();
    return newState
        .resetImage()
        .copyWith(isEditingMode: false, selectedNotes: [], text: '', startedUpdating: false);
  }

  Future<CategoryNotesState> _fetchNotes() async {
    final notes = await noteRepository.fetchNotes(state.category);
    notes.sort((e1, e2) => e2.created.compareTo(e1.created));
    return state.copyWith(notes: notes);
  }
}
