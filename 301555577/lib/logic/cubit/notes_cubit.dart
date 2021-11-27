import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/category_model.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/note_repository.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final NoteRepository noteRepository;
  final CategoryRepository categoryRepository;
  TextEditingController textInputController = TextEditingController();
  List<Category> categoryList = [];

  NotesCubit(
    NotesState initialState, {
    required this.noteRepository,
    required this.categoryRepository,
  }) : super(initialState);

  Future<void> fetchNotes(Category category) async {
    final categories = await categoryRepository.fetchCategories();
    if (categoryList.isNotEmpty) categoryList.clear();
    categoryList.addAll(categories);
    final notes = await noteRepository.fetchNotes(category);
    notes.sort((e1, e2) => e2.created.compareTo(e1.created));
    final selectedCategory = category;
    emit(
      NotesState(
        updateTime: DateTime.now(),
        category: category,
        notes: notes,
        selectedNotes: [],
        isEditMode: false,
        selectedCategory: selectedCategory,
      ),
    );
  }

  Future<void> addNote() async {
    if (state.isEditMode == false) {
      final note = Note(text: textInputController.value.text);
      textInputController.clear();
      await noteRepository.addNote(state.selectedCategory.id as int, note);
      fetchNotes(state.category);
    } else {
      var note = state.selectedNotes.first;
      note = note.copyWith(text: textInputController.value.text);
      textInputController.clear();
      await noteRepository.updateNote(note);
      fetchNotes(state.category);
    }
  }

  Future<void> select(Note note) async {
    final selectedNotes = state.selectedNotes;
    if (state.selectedNotes.contains(note)) {
      selectedNotes.remove(note);
    } else {
      selectedNotes.add(note);
    }
    emit(
      state.copyWith(
          selectedNotes: selectedNotes,
          updateTime: DateTime.now(),
          isEditMode: false),
    );
  }

  Future<void> clearSelected() async {
    emit(state.copyWith(
      selectedNotes: [],
      updateTime: DateTime.now(),
      isEditMode: false,
    ));
  }

  Future<void> deleteSelected() async {
    await noteRepository.deleteNotes(state.selectedNotes);
    fetchNotes(state.category);
  }

  Future<void> editNote() async {
    final selectedNote = state.selectedNotes.first;
    textInputController.text = selectedNote.text as String;
    emit(state.copyWith(isEditMode: true));
  }

  Future<void> copyToClipboard() async {
    final selectedNote = state.selectedNotes.first;
    Clipboard.setData(ClipboardData(text: selectedNote.text as String));
    emit(state.copyWith(selectedNotes: [], updateTime: DateTime.now()));
  }

  Future<void> changeSelectedCategory(int index) async {
    final selectedNotes = state.selectedNotes;
    noteRepository.updateNoteCategory(categoryList[index], selectedNotes);
    fetchNotes(state.category);
  }

  Future<void> fetchSearchNotes(String value) async {
    final notes = await noteRepository.fetchNotes(state.category);
    notes.sort((e1, e2) => e2.created.compareTo(e1.created));
    notes.removeWhere((element) => !element.text!.contains(value));

    emit(
      NotesState(
          updateTime: DateTime.now(),
          category: state.category,
          notes: notes,
          selectedNotes: [],
          isEditMode: false,
          selectedCategory: state.category),
    );
  }

  Future<void> showOrCloseSearchBar() async {
    emit(
      state.copyWith(
        showImagePicker: !state.showImagePicker,
        updateTime: DateTime.now(),
      ),
    );
  }

  Future<void> changeSendCategory(int index) async {
    emit(state.copyWith(
        selectedCategory: categoryList[index], updateTime: DateTime.now()));
  }
}
