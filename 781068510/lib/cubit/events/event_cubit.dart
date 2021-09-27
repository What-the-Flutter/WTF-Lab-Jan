import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/database/database_helper.dart';

import '../../models/note_model.dart';
import '../home_screen/home_cubit.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final int _defaultCategory = 0;

  final List<IconData> listOfEventsIcons = [
    Icons.cancel,
    Icons.movie,
    Icons.sports_basketball,
    Icons.sports_outlined,
    Icons.local_laundry_service,
    Icons.fastfood,
    Icons.run_circle_outlined,
  ];

  final DatabaseHelper _database = DatabaseHelper();

  EventCubit() : super(EventState(title: '', allNotes: []));

  late int pageID;

  void init(PageCategoryInfo note) async {
    pageID = await note.id!;
    var events = await _database.readAllEventsByIndex(note.id!);
    events.sort((a, b) => b.time.compareTo(a.time));
    emit(
      state.copyWith(
        title: note.title,
        selectedCategory: 0,
        allNotes: events,
      ),
    );
  }

  void setCurrentEventsList(List<Note> currentEventsList) =>
      emit(state.copyWith(allNotes: currentEventsList));

  void setEditMode() {
    emit(
      state.copyWith(
        isEditMode: !state.isEditMode,
      ),
    );
  }

  void addImageFromGallery() async {
    try {
      setIsPickingPhoto();
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setSelectedPhoto(imageTemporary.path);
      emit(state.copyWith(selectedPhoto: imageTemporary.path));
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void setChecked(int value) {
    emit(state.copyWith(checked: value));
  }

  void setMessageEditMode(bool isMessageEdit) {
    emit(state.copyWith(isTextEditMode: isMessageEdit));
  }

  void setCategory(int index) {
    emit(state.copyWith(selectedCategory: index));
  }

  void setPickedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void setReplyPage(BuildContext context, int index) {
    final page = context.read<HomeCubit>().state.pages[index];
    emit(
      state.copyWith(
        pageToReply: page,
        pageReplyIndex: index,
      ),
    );
  }

  void setDefaultCategory() {
    emit(state.copyWith(selectedCategory: 0));
  }

  void setIsChangingCategory() {
    emit(state.copyWith(isChangingCategory: !state.isChangingCategory));
  }

  void setIsPickingPhoto() {
    emit(state.copyWith(isPickingPhoto: !state.isPickingPhoto));
  }

  void setSelectedPhoto(String? path) {
    emit(state.copyWith(selectedPhoto: path));
  }

  void deleteSelectedPhoto() {
    emit(state.copyWith(selectedPhoto: ''));
  }

  void unselectEvents() {
    emit(state.copyWith(activeNotes: []));
  }

  void selectEvent(int index) {
    var updatedSelectedEvents = List<int>.from(state.activeNotes);
    if (state.activeNotes.contains(index)) {
      updatedSelectedEvents.remove(index);
      if (updatedSelectedEvents.isEmpty) {
        setEditMode();
      }
    } else {
      updatedSelectedEvents.add(index);
    }
    emit(
      state.copyWith(activeNotes: updatedSelectedEvents),
    );
  }

  void copyDataFromEvents() {
    final message = state.allNotes[state.activeNotes[0]].description;
    if (message != null) {
      Clipboard.setData(
        ClipboardData(text: message),
      );
    }
    setEditMode();
    unselectEvents();
  }

  void replyEvents() async {
    for (var i = state.activeNotes.length - 1; i >= 0; i--) {
      state.allNotes.elementAt(state.activeNotes[i]).tableId =
          state.pageReplyIndex! + 1;
      _database.updateEvent(
        pageID,
        state.allNotes.elementAt(state.activeNotes[i]),
      );
      state.allNotes.removeAt(state.activeNotes[i]);
    }
    setCurrentEventsList(state.allNotes);
  }

  void setBookmarkedOnly() {
    emit(state.copyWith(isBookmarkedNoteMode: !state.isBookmarkedNoteMode));
  }

  void setSearchState() {
    emit(state.copyWith(isSearchState: !state.isSearchState));
  }

  void setInputText(String text) {
    emit(state.copyWith(textInput: text));
  }

  void setSearchText(String text) {
    emit(state.copyWith(searchInput: text));
  }

  void setIsAddingHashTag() {
    emit(state.copyWith(isAddingHashTag: !state.isAddingHashTag));
  }

  void checkInput() {
    if (!state.textInput!.contains('#') && state.isAddingHashTag) {
      setIsAddingHashTag();
    } else if (state.textInput!.contains('#') && !state.isAddingHashTag) {
      setIsAddingHashTag();
    }
    print(state.isAddingHashTag);
  }

  void addToBookmarks(int index) async {
    var updatedNote = state.allNotes[index];
    updatedNote.isBookmarked = !updatedNote.isBookmarked;
    await _database.updateEvent(pageID, updatedNote);

    state.allNotes[index].isBookmarked == false ? true : false;
    setCurrentEventsList(state.allNotes);
  }

  void addSelectedToBookmarks() async {
    var selected = state.activeNotes;
    for (var el in selected) {
      var updatedNote = state.allNotes[el];
      updatedNote.isBookmarked = !updatedNote.isBookmarked;
      await _database.updateEvent(pageID, updatedNote);
      state.allNotes[el].isBookmarked == false ? true : false;
    }

    setCurrentEventsList(state.allNotes);
  }

  void addMessageEvent() async {
    var updatedNote = Note(
      time: DateTime.now(),
      description: state.textInput,
      formattedTime: '${DateTime.now().hour}:${DateTime.now().minute}',
      isBookmarked: false,
      category: state.selectedCategory,
      tableId: pageID,
    );
    if (state.activeNotes.length == 1 && state.isTextEditMode) {
      if (state.textInput == '') {
        await _database.deleteEvent(
            pageID, state.allNotes.elementAt(state.activeNotes[0]).id!);
        state.allNotes.removeAt(state.activeNotes[0]);
      } else {
        updatedNote = state.allNotes[state.activeNotes[0]];
        updatedNote.description = state.textInput;
        updatedNote.updateSendTime();
        await _database.updateEvent(pageID, updatedNote);
      }
      emit(state.copyWith(activeNotes: []));
    } else if (state.textInput != '' || state.selectedPhoto != '') {
      updatedNote.category = 0;
      if (state.selectedCategory != _defaultCategory) {
        updatedNote.category = state.selectedCategory;
        setDefaultCategory();
      }
      if (state.selectedPhoto != '') {
        updatedNote.image = state.selectedPhoto;
        deleteSelectedPhoto();
      }
      if (state.selectedDate != null) {
        updatedNote.time = state.selectedDate!;
        updatedNote.formattedTime =
            '${updatedNote.time.hour}:${updatedNote.time.minute}';
      }
      updatedNote.description = state.textInput;
      emit(state.copyWith(isAddingHashTag: false));
      emit(state.copyWith(textInput: ''));
      state.allNotes.insert(0, await _database.addEvent(pageID, updatedNote));
      state.allNotes.sort((a, b) => b.time.compareTo(a.time));
    }
    setCurrentEventsList(await state.allNotes);
  }

  void deleteEvent() async {
    var activeNotes = List<int>.from(state.activeNotes)..sort();
    for (var i = state.activeNotes.length - 1; i >= 0; i--) {
      var id = state.allNotes.elementAt(activeNotes[i]).id!;
      await _database.deleteEvent(pageID, id);
      state.allNotes.removeAt(activeNotes[i]);
    }
    setCurrentEventsList(state.allNotes);
    setEditMode();
    unselectEvents();
  }
}
