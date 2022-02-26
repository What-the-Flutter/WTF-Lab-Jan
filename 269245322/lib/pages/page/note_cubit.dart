import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../../database/firebase_repository.dart';
import '../../database/sqlite_repository.dart';
import '../../models/note_model.dart';
import '../../models/page_model.dart';
import '../../services/entity_repository.dart';
import '../../services/firebase_file_service.dart';
import '../../shared_preferences/sp_settings_helper.dart';
import 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final SharedPreferencesProvider _sharedPreferencesProvider =
      SharedPreferencesProvider();

  late final IRepository<PageModel> dbPageHelper;

  late final IRepository<NoteModel> dbNoteHelper;

  NoteCubit()
      : super(
          const NoteState(
            isUserEditingeNote: false,
            selcetedNotes: [],
            showNoteIconMenue: false,
            isSerchBarDisplayed: false,
          ),
        );

  void initPage(PageModel page) {
    dbPageHelper = (_sharedPreferencesProvider.getDatabase() == 0)
        ? FireBasePageHelper()
        : SqlitePageRepository();

    dbNoteHelper = (_sharedPreferencesProvider.getDatabase() == 0)
        ? FireBaseNoteHelper()
        : SqliteNoteRepository();

    emit(
      state.copyWith(
        notesList: page.notesList,
        page: page,
        noteIcon: page.icon,
      ),
    );
  }

  bool areAppBarActionsDisplayed() {
    final bool functionResult;

    state.selcetedNotes!.isEmpty
        ? functionResult = false
        : functionResult = true;

    return functionResult;
  }

  bool isEditIconEnable() {
    final bool functionResult;

    (state.selcetedNotes!.length == 1)
        ? functionResult = true
        : functionResult = false;

    return functionResult;
  }

  void showSerchBar(bool dispalayed, TextEditingController searhController) {
    bool newIsSerchBarDisplayed;

    if (dispalayed) {
      newIsSerchBarDisplayed = true;
    } else {
      newIsSerchBarDisplayed = false;
      searhController.text = '';
    }
    emit(state.copyWith(isSerchBarDisplayed: newIsSerchBarDisplayed));
  }

  bool getSerchBarDisplayedState() {
    return state.isSerchBarDisplayed;
  }

  void copyDataToBuffer() {
    var bufferData = '';
    for (final currentNote in state.selcetedNotes!) {
      bufferData += '${currentNote.data} ';
    }
    Clipboard.setData(ClipboardData(text: bufferData));
    setAllNotesSelectedUnselected(false);
  }

  void search(String searchString) {
    final newNoteList = state.page!.notesList;
    NoteModel newNote;
    if (searchString != '') {
      for (final note in newNoteList) {
        if (note.data.contains(searchString)) {
          newNote = note.copyWith(isSearched: true);
        } else {
          newNote = note.copyWith(isSearched: false);
        }
        newNoteList[newNoteList.indexOf(note)] = newNote;
        emit(state.copyWith(notesList: newNoteList));
      }
    } else {
      for (final note in newNoteList) {
        newNote = note.copyWith(isSearched: false);
        newNoteList[newNoteList.indexOf(note)] = newNote;
      }

      emit(state.copyWith(notesList: newNoteList));
    }
  }

  int createId() {
    final id = int.parse(DateTime.now().toString().substring(20, 26));
    print(id);
    return id;
  }

  void addNoteToList(TextEditingController controller) async {
    final noteInput = controller.text;
    final headingText = '${state.page!.title}';
    var noteCounter = 0;
    final noteURL = await uploadFile(headingText);
    final noteTags = _getStringOfTagsFromStringInput(noteInput);

    final newNote = NoteModel(
      id: createId(),
      heading: headingText,
      data: noteInput,
      icon: state.noteIcon!,
      isSearched: false,
      isFavorite: false,
      isChecked: false,
      downloadURL: noteURL,
      tags: noteTags,
    );

    final newNoteList = state.notesList!;
    if (state.isUserEditingeNote) {
      final editableNote = state.selcetedNotes!.first;
      //findig user's selected note in the note list and changing it's data with new value
      for (final note in newNoteList) {
        if (note.heading == editableNote.heading) {
          newNoteList[noteCounter] =
              note.copyWith(data: controller.text, isChecked: false);
          dbNoteHelper.update(newNoteList[noteCounter], state.page!.id);
        }
        noteCounter++;
      }
    } else {
      final newPage =
          state.page!.copyWith(numOfNotes: state.page!.numOfNotes + 1);
      emit(state.copyWith(page: newPage));
      dbPageHelper.update(newPage, null);
      newNoteList.add(newNote);
      dbNoteHelper.insert(newNote, newPage.id);
      uploadFile(newNote.heading);
    }
    emit(state.copyWith(notesList: newNoteList));

    final newIsUserEditingeNoteState = false;
    emit(state.copyWith(isUserEditingeNote: newIsUserEditingeNoteState));

    final newPage =
        state.page!.copyWith(lastModifedDate: DateTime.now().toString());
    emit(state.copyWith(page: newPage));

    setAllNotesSelectedUnselected(false);
    //refresh data note input field
    controller.text = '';
  }

  void setSelectesCheckBoxState(bool selected, int index) {
    final newNote = state.notesList![index].copyWith(isChecked: selected);
    final newNotesList = state.notesList!;
    newNotesList[index] = newNote;
    emit(state.copyWith(notesList: newNotesList));
  }

  void addNoteToSelectedNotesList(int index) {
    final newSelectedList = state.selcetedNotes!;
    setSelectesCheckBoxState(true, index);
    newSelectedList.add(state.page!.notesList[index]);
    emit(state.copyWith(selcetedNotes: newSelectedList));
  }

  void removeNoteFromSelectedNotesList(int index) {
    final newSelectedList = <NoteModel>[];
    for (final note in state.selcetedNotes!) {
      newSelectedList.add(note);
    }

    if (newSelectedList.isNotEmpty) {
      final noteToDelete = state.page!.notesList[index];
      for (final note in state.selcetedNotes!) {
        if (note.heading == noteToDelete.heading) {
          newSelectedList.remove(note);
        }
      }
      emit(state.copyWith(selcetedNotes: newSelectedList));
    }
  }

  void setAllNotesSelectedUnselected(bool selectAll) {
    for (var indexCounter = 0;
        indexCounter < state.notesList!.length;
        indexCounter++) {
      selectAll
          ? addNoteToSelectedNotesList(indexCounter)
          : removeNoteFromSelectedNotesList(indexCounter);
    }
  }

  int getIcon() {
    return state.noteIcon!;
  }

  void deleteFromNoteList() {
    final newNoteList = state.notesList!;
    for (final currentNote in state.selcetedNotes!) {
      newNoteList.remove(currentNote);
      final newPage =
          state.page!.copyWith(numOfNotes: state.page!.numOfNotes - 1);
      emit(state.copyWith(page: newPage));
      dbPageHelper.update(newPage, null);
      dbNoteHelper.delete(currentNote, newPage.id);
    }

    emit(state.copyWith(notesList: newNoteList));
    setAllNotesSelectedUnselected(false);
  }

  void addNoteToFavorite() {
    final newNoreList = state.notesList!;
    for (final currentNote in state.selcetedNotes!) {
      if (currentNote.isFavorite == true) {
        final newNote =
            currentNote.copyWith(isFavorite: false, isChecked: false);
        newNoreList[newNoreList.indexOf(currentNote)] = newNote;
        dbNoteHelper.update(newNote, state.page!.id);
      } else {
        final newNote =
            currentNote.copyWith(isFavorite: true, isChecked: false);
        newNoreList[newNoreList.indexOf(currentNote)] = newNote;
        dbNoteHelper.update(newNote, state.page!.id);
      }
    }
    emit(state.copyWith(notesList: newNoreList));

    setAllNotesSelectedUnselected(false);
  }

  String editNote() {
    final newIsUserEditingeNoteState = true;
    emit(state.copyWith(isUserEditingeNote: newIsUserEditingeNoteState));
    return state.selcetedNotes!.first.data;
  }

  void showNoteIconMenu(bool show) {
    emit(state.copyWith(showNoteIconMenue: show));
  }

  void setNewNoteIcon(int icon) {
    emit(state.copyWith(noteIcon: icon));
    showNoteIconMenu(false);
  }

  bool getShowNoteIconMenueState() {
    return state.showNoteIconMenue;
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

    final path = result.files.single.path!;
    emit(state.copyWith(file: File(path)));
  }

  Future<String> uploadFile(String heading) async {
    if (state.file == null) return '';

    final fileName = basename(state.file!.path);
    final destination = '$heading/$fileName';

    final fileService = FileService();
    final task = await fileService.uploadFile(destination, state.file!);

    if (task == null) return '';
    final snapShot = await task.whenComplete(() {});
    final downloadURL = await snapShot.ref.getDownloadURL();
    return downloadURL;
  }

  String _getStringOfTagsFromStringInput(String inputStr) {
    var tagsString = '';
    var numOfTags = 0;

    for (var i = 0; i < inputStr.length; i++) {
      if (inputStr[i] == '#') numOfTags++;
    }
    final listOfTags = <String>[];
    final listOfWords = inputStr.split(' ');
    for (final word in listOfWords) {
      if (word.contains('#')) listOfTags.add(word);
    }
    for (final tag in listOfTags) {
      tagsString += tag;
    }
    if (numOfTags != listOfTags.length) tagsString = '';
    return tagsString;
  }

  double getTextSize() {
    var textSize = 10.0;
    final factor = (_sharedPreferencesProvider.getTextSize() + 1) * 5;
    textSize = textSize + factor;
    return textSize;
  }

  bool isCenterAlignent() {
    final centerAligment =
        (_sharedPreferencesProvider.getALigment() == 0) ? false : true;
    return centerAligment;
  }
}
