import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../../database/firebase_db_helper.dart';
import '../../models/note_model.dart';
import '../../models/page_model.dart';
import '../../services/firebase_file_service.dart';
import 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  //final DBHelper _dbHelper = DBHelper();
  final FireBaseNoteHelper _fireBaseNoteHelper = FireBaseNoteHelper();
  final FireBasePageHelper _fireBasePageHelper = FireBasePageHelper();

  NoteCubit()
      : super(const NoteState(
          isUserEditingeNote: false,
          selcetedNotes: [],
          showNoteIconMenue: false,
          isSerchBarDisplayed: false,
        ));

  void initPage(PageModel page) {
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
    for (var currentNote in state.selcetedNotes!) {
      bufferData += '${currentNote.data} ';
    }
    Clipboard.setData(ClipboardData(text: bufferData));
    setAllNotesSelectedUnselected(false);
  }

  void search(String searchString) {
    final newNoteList = state.page!.notesList;
    NoteModel newNote;
    if (searchString != '') {
      for (var note in newNoteList) {
        if (note.data.contains(searchString)) {
          newNote = note.copyWith(isSearched: true);
        } else {
          newNote = note.copyWith(isSearched: false);
        }
        newNoteList[newNoteList.indexOf(note)] = newNote;
        emit(state.copyWith(notesList: newNoteList));
      }
    } else {
      for (var note in newNoteList) {
        newNote = note.copyWith(isSearched: false);
        newNoteList[newNoteList.indexOf(note)] = newNote;
      }

      emit(state.copyWith(notesList: newNoteList));
    }
  }

  void addNoteToList(TextEditingController controller) async {
    final noteInput = controller.text;
    final headingText = '${state.page!.title} ${state.page!.numOfNotes}';
    var noteCounter = 0;

    final newNote = NoteModel(
      heading: headingText,
      data: noteInput,
      icon: state.noteIcon!,
      isSearched: false,
      isFavorite: false,
      isChecked: false,
    );

    var newNoteList = state.notesList!;
    if (state.isUserEditingeNote) {
      final editableNote = state.selcetedNotes!.first;
      //findig user's selected note in the note list and changing it's data with new value
      for (var note in newNoteList) {
        if (note.heading == editableNote.heading) {
          newNoteList[noteCounter] =
              note.copyWith(data: controller.text, isChecked: false);
          //_dbHelper.editNote(newNoteList[noteCounter], state.page!.title);
          _fireBaseNoteHelper.update(newNoteList[noteCounter],
              state.page!.title, state.page!.fireBaseTitle!);
        }
        noteCounter++;
      }
    } else {
      final newPage =
          state.page!.copyWith(numOfNotes: state.page!.numOfNotes + 1);
      emit(state.copyWith(page: newPage));
      //_dbHelper.updatePage(newPage, newPage.title);
      _fireBasePageHelper.update(newPage, null, null);
      newNoteList.add(newNote);
      //_dbHelper.insertNote(newNote, newPage.title);
      _fireBaseNoteHelper.insert(
          newNote, newPage.title, newPage.fireBaseTitle!);
      uploadFile(newNote.heading);

      var noteWithURL =
          newNote.copyWith(downloadURL: await uploadFile(newNote.heading));
      _fireBaseNoteHelper.update(
          noteWithURL, state.page!.title, state.page!.fireBaseTitle!);

      if (_getStringOfTagsFromStringInput(newNote.data).isNotEmpty) {
        var noteWithTags = newNote.copyWith(
            tags: _getStringOfTagsFromStringInput(newNote.data));
        _fireBaseNoteHelper.update(
            noteWithTags, state.page!.title, state.page!.fireBaseTitle!);
      }
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
    var newSelectedList = <NoteModel>[];
    for (var note in state.selcetedNotes!) {
      newSelectedList.add(note);
    }
    setSelectesCheckBoxState(true, index);
    newSelectedList.add(state.page!.notesList[index]);
    emit(state.copyWith(selcetedNotes: newSelectedList));
  }

  void removeNoteFromSelectedNotesList(int index) {
    var newSelectedList = <NoteModel>[];
    for (var note in state.selcetedNotes!) {
      newSelectedList.add(note);
    }

    if (newSelectedList.isNotEmpty) {
      var noteToDelete = state.page!.notesList[index];
      for (var note in state.selcetedNotes!) {
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
    for (var currentNote in state.selcetedNotes!) {
      newNoteList.remove(currentNote);
      final newPage =
          state.page!.copyWith(numOfNotes: state.page!.numOfNotes - 1);
      emit(state.copyWith(page: newPage));
      //_dbHelper.updatePage(newPage, newPage.title);
      _fireBasePageHelper.update(newPage, null, null);
      //_dbHelper.deleteNote(currentNote);
      _fireBaseNoteHelper.delete(currentNote, null, state.page!.fireBaseTitle!);
    }

    emit(state.copyWith(notesList: newNoteList));
    setAllNotesSelectedUnselected(false);
  }

  void addNoteToFavorite() {
    final newNoreList = state.notesList!;
    for (var currentNote in state.selcetedNotes!) {
      if (currentNote.isFavorite == true) {
        var newNote = currentNote.copyWith(isFavorite: false, isChecked: false);
        newNoreList[newNoreList.indexOf(currentNote)] = newNote;
        //_dbHelper.editNote(newNote, state.page!.title);
        _fireBaseNoteHelper.update(
            newNote, state.page!.title, state.page!.fireBaseTitle!);
      } else {
        var newNote = currentNote.copyWith(isFavorite: true, isChecked: false);
        newNoreList[newNoreList.indexOf(currentNote)] = newNote;
        //_dbHelper.editNote(newNote, state.page!.title);
        _fireBaseNoteHelper.update(
            newNote, state.page!.title, state.page!.fireBaseTitle!);
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

    for (var i = 0; i < tagsString.length; i++) {
      if (tagsString[i] == '#') numOfTags++;
    }
    var listOfTags = <String>[];
    var listOfWords = tagsString.split(' ');
    for (var word in listOfWords) {
      if (word.contains('#')) listOfTags.add(word);
    }
    for (var tag in listOfTags) {
      tagsString += tag;
    }
    if (numOfTags != listOfTags.length) tagsString = '';

    return tagsString;
  }
}
