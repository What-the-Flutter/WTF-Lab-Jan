import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/note.dart';
import '../../../../repository/category_repository.dart';
import '../../../../repository/note_repository.dart';
import 'category_notes_event.dart';
import 'category_notes_state.dart';

class CategoryNotesBloc extends Bloc<CategoryNotesEvent, CategoryNotesState> {
  final NoteRepository noteRepository;
  final CategoryRepository categoryRepository;

  CategoryNotesBloc(
    CategoryNotesState initialState, {
    required this.noteRepository,
    required this.categoryRepository,
  }) : super(initialState);

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
    } else if (event is ShowCategoriesEvent) {
      yield await _showCategoriesEvent();
    } else if (event is CategorySelectedEvent) {
      yield state.copyWith(tempCategory: event.category, showCategoryPicker: false);
    } else if (event is CategoryPickerClosedEvent) {
      yield state.copyWith(showCategoryPicker: false);
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
        tempCategory: state.category);
  }

  Future<CategoryNotesState> _addNote(AddNoteEvent event) async {
    final newState;
    if (state.category.id != null &&
        state.tempCategory != null &&
        state.tempCategory?.id != state.category.id) {
      await noteRepository.addNote(
        state.tempCategory!.id!,
        Note(image: state.image?.path, text: state.text, direction: event.direction),
      );
      newState = state;
    } else {
      await noteRepository.addNote(
        state.category.id!,
        Note(image: state.image?.path, text: state.text, direction: event.direction),
      );
      newState = await _fetchNotes();
    }
    return newState.resetImage().copyWith(text: '', tempCategory: state.category);
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
    if (state.tempCategory == state.category) {
      await noteRepository.updateNote(note);
    } else {
      await noteRepository.updateNoteCategory(state.tempCategory!, note);
    }
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

  Future<CategoryNotesState> _showCategoriesEvent() async {
    if (state.defaultCategories == null) {
      final categories = await categoryRepository.fetchCategories();
      return state.copyWith(categories: categories, showCategoryPicker: true);
    } else {
      return state.copyWith(showCategoryPicker: true);
    }
  }
}
