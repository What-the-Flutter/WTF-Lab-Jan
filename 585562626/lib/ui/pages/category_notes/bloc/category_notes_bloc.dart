import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';

import '../../../../models/note.dart';
import '../../../../models/tag.dart';
import '../../../../repository/category_repository.dart';
import '../../../../repository/note_repository.dart';
import '../../../../repository/preferences_provider.dart';
import 'category_notes_event.dart';
import 'category_notes_state.dart';

class CategoryNotesBloc extends Bloc<CategoryNotesEvent, CategoryNotesState> {
  final NoteRepository noteRepository;
  final CategoryRepository categoryRepository;
  final PreferencesProvider preferencesProvider;

  CategoryNotesBloc(
    CategoryNotesState initialState, {
    required this.noteRepository,
    required this.categoryRepository,
    required this.preferencesProvider,
  }) : super(initialState);

  @override
  Stream<CategoryNotesState> mapEventToState(CategoryNotesEvent event) async* {
    if (event is FetchNotesEvent) {
      yield await _initialFetch();
    } else if (event is SwitchStarEvent) {
      yield* _switchStar(state);
    } else if (event is SwitchEditingModeEvent) {
      yield _switchEditingMode();
    } else if (event is AddNoteEvent) {
      yield* _addNote(event, state);
    } else if (event is SwitchNoteSelectionEvent) {
      yield _switchNoteSelection(event);
    } else if (event is DeleteSelectedNotesEvent) {
      yield* _deleteNotes(state);
    } else if (event is StartEditingEvent) {
      yield _startEditing();
    } else if (event is UpdateNoteEvent) {
      yield* _updateNote(state);
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
    } else if (event is UpdateNoteDateEvent) {
      yield* _updateNoteDate(event, state);
    } else if (event is OpenSearchEvent) {
      yield await _openSearch();
    } else if (event is OpenSearchClosedEvent) {
      yield state.copyWith(showSearch: false);
    }
  }

  Future<CategoryNotesState> _initialFetch() async {
    final isRightAlignmentEnabled = await preferencesProvider.bubbleAlignment();
    final isDateTimeModificationEnabled = await preferencesProvider.dateTimeModificationEnabled();
    final newState = await _fetchNotes();
    return newState.copyWith(
      isRightAlignmentEnabled: isRightAlignmentEnabled,
      isDateTimeModificationEnabled: isDateTimeModificationEnabled,
    );
  }

  Stream<CategoryNotesState> _switchStar(CategoryNotesState oldState) async* {
    final notes = List<Note>.from(oldState.notes);
    final updatedNotes = oldState.selectedNotes.map((e) => e.copyWith(hasStar: !e.hasStar));
    notes.removeWhere((element) => oldState.selectedNotes.contains(element));
    notes.addAll(updatedNotes);
    notes.sort((e1, e2) => e2.created.compareTo(e1.created));
    yield state.copyWith(notes: notes);
    final result = await noteRepository.updateNotes(updatedNotes);
    if (!result) {
      yield await _fetchNotes();
    }
  }

  CategoryNotesState _switchEditingMode() {
    return state.copyWith(
      isEditingMode: !state.isEditingMode,
      selectedNotes: [],
      startedUpdating: false,
      text: '',
      tempCategory: state.category,
    );
  }

  Stream<CategoryNotesState> _addNote(AddNoteEvent event, CategoryNotesState oldState) async* {
    // add note to tempCategory
    if (state.category.id != null &&
        state.tempCategory != null &&
        state.tempCategory?.id != state.category.id) {
      yield oldState.resetImage().copyWith(text: '', tempCategory: state.category);
      final result = await noteRepository.addNote(
        state.tempCategory!.id!,
        Note(image: state.image?.path, text: state.text, direction: event.direction),
      );
      if (result == 0) {
        yield state.copyWith(notInsertedForAnotherCategory: true);
      }
    } else {
      final notes = List<Note>.from(oldState.notes);
      final note = Note(image: state.image?.path, text: state.text, direction: event.direction);
      notes.insert(0, note);
      yield oldState.resetImage().copyWith(notes: notes, text: '', tempCategory: state.category);
      final result = await noteRepository.addNote(state.category.id!, note);
      if (result == 0) {
        yield oldState.resetImage().copyWith(text: '', tempCategory: state.category);
      } else {
        final newNote = note.copyWith(id: result);
        notes.removeAt(0);
        notes.insert(0, newNote);
        yield oldState
            .resetImage()
            .copyWith(notes: notes.toList(), text: '', tempCategory: state.category);
      }
    }
    final tags = extractHashTags(state.text ?? '').map((e) => Tag(name: e));
    for (final tag in tags) {
      await noteRepository.addTag(tag);
    }
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

  Stream<CategoryNotesState> _deleteNotes(CategoryNotesState oldState) async* {
    final notes = List<Note>.from(oldState.notes);
    notes.removeWhere((element) => oldState.selectedNotes.contains(element));
    yield oldState.copyWith(
      notes: notes,
      selectedNotes: [],
      isEditingMode: false,
      startedUpdating: false,
    );
    final result = await noteRepository.deleteNotes(state.selectedNotes);
    if (!result) {
      final newState = await _fetchNotes();
      yield newState.copyWith(selectedNotes: [], isEditingMode: false, startedUpdating: false);
    }
  }

  CategoryNotesState _startEditing() {
    return state.copyWith(
      startedUpdating: true,
      text: state.selectedNotes.first.text ?? state.text,
      showImagePicker: state.selectedNotes.first.image != null,
    );
  }

  Stream<CategoryNotesState> _updateNote(CategoryNotesState oldState) async* {
    final note = oldState.selectedNotes.first.copyWith(
      text: oldState.text,
      image: oldState.image?.path,
    );
    final index = oldState.notes.indexWhere((element) => element.id == note.id);
    final notes = List<Note>.from(oldState.notes);
    notes.removeAt(index);
    final result;
    if (oldState.tempCategory == oldState.category) {
      notes.insert(index, note);
      yield oldState.resetImage().copyWith(
            notes: notes,
            isEditingMode: false,
            selectedNotes: [],
            text: '',
            startedUpdating: false,
          );
      result = await noteRepository.updateNote(note);
    } else {
      yield oldState.resetImage().copyWith(
            notes: notes,
            isEditingMode: false,
            selectedNotes: [],
            text: '',
            startedUpdating: false,
          );
      result = await noteRepository.updateNoteCategory(oldState.tempCategory!, note);
    }
    if (result == 0) {
      yield oldState;
    }
  }

  Future<CategoryNotesState> _fetchNotes() async {
    final notes = await noteRepository.fetchNotes(state.category);
    notes.sort((e1, e2) => e2.created.compareTo(e1.created));
    return state.copyWith(notes: notes);
  }

  Future<CategoryNotesState> _showCategoriesEvent() async {
    if (state.existingCategories == null) {
      final categories = await categoryRepository.fetchCategories();
      return state.copyWith(categories: categories, showCategoryPicker: true);
    } else {
      return state.copyWith(showCategoryPicker: true);
    }
  }

  Stream<CategoryNotesState> _updateNoteDate(
    UpdateNoteDateEvent event,
    CategoryNotesState oldState,
  ) async* {
    final newNote = event.note.copyWith(createdAt: event.dateTime);
    final notes = List<Note>.from(oldState.notes);
    final index = notes.indexWhere((element) => element.id == newNote.id);
    notes.removeAt(index);
    notes.insert(index, newNote);
    notes.sort((e1, e2) => e2.created.compareTo(e1.created));
    yield oldState.copyWith(notes: notes);
    final result = await noteRepository.updateNote(newNote);
    if (result == 0) {
      yield oldState;
    }
  }

  Future<CategoryNotesState> _openSearch() async {
    final tags = await noteRepository.fetchTags();
    return state.copyWith(tags: tags, showSearch: true);
  }
}
