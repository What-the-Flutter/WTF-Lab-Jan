import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/note_model.dart';
import '../../models/page_model.dart';
import 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(const NoteState(isUserEditingeNote: false));

  void init(PageModel page) {
    emit(
      state.copyWith(
        notesList: page.notesList,
        selcetedNotes: [],
        page: page,
        showNoteIconMenue: false,
        isSerchBarDisplayed: false,
        noteIcon: page.icon,
      ),
    );
  }

  bool areAppBarActionsDisplayed() {
    if (state.selcetedNotes!.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool isEditIconEnable() {
    if (state.selcetedNotes!.length == 1) {
      return true;
    } else {
      return false;
    }
  }

  void copyDataToBuffer() {
    var bufferData = '';
    for (var currentNote in state.selcetedNotes!) {
      bufferData += '${currentNote.data} ';
    }
    Clipboard.setData(ClipboardData(text: bufferData));
    setAllNotesSelectedUnselected(false);
  }

  void setAllNotesSelectedUnselected(bool selectAll) {
    var newSelectedList = <NoteModel>[];
    if (selectAll) {
      for (var note in state.notesList!) {
        note.isChecked = true;
        newSelectedList.add(note);
      }
    } else {
      for (var note in state.selcetedNotes!) {
        note.isChecked = false;
      }
    }
    emit(state.copyWith(selcetedNotes: newSelectedList));
  }

  void search(String searchString) {
    var newNoteList = state.page!.notesList;
    if (searchString != '') {
      for (var note in newNoteList) {
        if (note.data.contains(searchString)) {
          note.isSearched = true;
        } else {
          note.isSearched = false;
        }
      }
      emit(state.copyWith(notesList: newNoteList));
    } else {
      for (var note in newNoteList) {
        note.isSearched = false;
      }
      emit(state.copyWith(notesList: newNoteList));
    }
  }

  void addNoteToList(TextEditingController controller) {
    late String nodeInput;

    nodeInput = controller.text;
    var newNote = NoteModel(
      heading: state.page!.numOfNotes.toString(),
      data: nodeInput,
      icon: state.noteIcon!,
    );

    var newNoteList = state.notesList;
    if (state.isUserEditingeNote!) {
      var editableNote = state.selcetedNotes!.first;
      //findig user's selected note in the note list and changing it's data with new value
      for (var note in newNoteList!) {
        if (note.heading == editableNote.heading) {
          note.data = controller.text;
        }
      }
    } else {
      state.page!.numOfNotes++;
      newNoteList!.add(newNote);
    }
    emit(state.copyWith(notesList: newNoteList));
    var newIsUserEditingeNoteState = false;
    emit(state.copyWith(isUserEditingeNote: newIsUserEditingeNoteState));
    setAllNotesSelectedUnselected(false);
    state.page!.lastModifedDate = DateTime.now();
    controller.text = '';
  }

  void setSelectesCheckBoxState(bool selected, int index) {
    var newNote = state.notesList![index];
    newNote.isChecked = selected;
    emit(state.copyWith(note: newNote));
  }

  void addNoteToSelectedNotesList(int index) {
    var newSelectedList = state.selcetedNotes!;
    newSelectedList.add(state.page!.notesList[index]);
    emit(state.copyWith(selcetedNotes: newSelectedList));
    print(state.selcetedNotes!.length);
  }

  void setNewIcon(IconData icon) {
    print('set');
    var newNoteIcon = icon;
    emit(state.copyWith(noteIcon: newNoteIcon));
    print(state.noteIcon);
  }

  IconData getIcon() {
    return state.noteIcon!;
  }

  void removeNoteFromSelectedNotesList(int index) {
    var newSelectedList = state.selcetedNotes!;
    newSelectedList.remove(state.page!.notesList[index]);
    emit(state.copyWith(selcetedNotes: newSelectedList));
  }

  void deleteFromNoteList() {
    var newNoreList = state.notesList;
    for (var currentNote in state.selcetedNotes!) {
      newNoreList!.remove(currentNote);
    }
    emit(state.copyWith(notesList: newNoreList));

    setAllNotesSelectedUnselected(false);
  }

  void addNoteToFavorite() {
    for (var currentNote in state.selcetedNotes!) {
      currentNote.isFavorite == false
          ? currentNote.isFavorite = true
          : currentNote.isFavorite = false;
      emit(state.copyWith(note: currentNote));
    }
    setAllNotesSelectedUnselected(false);
  }

  String editNote() {
    var newIsUserEditingeNoteState = true;
    emit(state.copyWith(isUserEditingeNote: newIsUserEditingeNoteState));
    return state.selcetedNotes!.first.data;
  }

  void showNoteIconMenu(bool show) {
    bool newShowNoteIconMenue;

    if (show) {
      newShowNoteIconMenue = true;
    } else {
      var newNoteList = state.page!.notesList;
      newShowNoteIconMenue = false;
      emit(state.copyWith(notesList: newNoteList));
    }
    emit(state.copyWith(showNoteIconMenue: newShowNoteIconMenue));
  }

  bool getShowNoteIconMenueState() {
    return state.showNoteIconMenue!;
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
  //krestik close() when click

  bool getSerchBarDisplayedState() {
    return state.isSerchBarDisplayed!;
  }
}
