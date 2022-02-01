import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../database/database.dart';
import '../../database/firebase/storage_provider.dart';
import '../../entity/entities.dart';
import 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  late final StreamSubscription _sub;

  ChatPageCubit() : super(ChatPageState.initial());

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }

  void findElements() {
    emit(state.duplicate(
        searchMessages: state.elements!
            .where((element) => element.description
                .toLowerCase()
                .contains(state.searchController!.text.toLowerCase()))
            .toList()));
  }

  void getElements(Topic topic) =>
      _sub = MessageRepository.loadElements(topic).listen(_updateMessages);

  Future<void> _updateMessages(List<Message> data) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    emit(state.duplicate(elements: data));
  }

  void onSelect(Message message) {
    if (state.selected!.contains(message)) {
      state.selected!.remove(message);
    } else {
      state.selected!.add(message);
    }
  }

  void moveSelected(Topic topic) {
    for (var item in state.selected!) {
      MessageRepository.remove(item);
      item.topic = topic;
      MessageRepository.add(item);
    }
    state.selected!.clear();
    if (state.searchPage) {
      findElements();
    } else {
      emit(state.duplicate());
    }
  }

  void deleteSelected() {
    for (var item in state.selected!) {
      MessageRepository.remove(item);
      state.elements!.remove(item);
    }
    state.selected!.clear();
    if (state.searchPage) {
      findElements();
    } else {
      emit(state.duplicate());
    }
  }

  void deleteMessage(int index) {
    if (state.editingFlag && state.editingIndex == index) {
      finishEditing(state.messages[index].runtimeType is Event);
    }
    final deleted = state.messages[index];
    MessageRepository.remove(deleted);
    state.elements!.remove(deleted);
    if (state.searchPage) {
      findElements();
    } else {
      emit(state.duplicate());
    }
  }

  void clearSelection() => state.selected!.clear();

  void setSelection(bool val) => emit(state.duplicate(selectionFlag: val));

  void startEditing(int index, Message o) {
    emit(state.duplicate(
      editingIndex: index,
      editingFlag: true,
      imageName: o.imageName,
    ));
    state.descriptionController!.text = o.description;
    if (o is Event) {
      _onEditEvent(o);
    }
    changeAddedTypeTo(getTypeId(o));
  }

  void changeAddedType() {
    emit(state.duplicate(
      addedType: (state.addedType + 1) % 3,
      addedIcon: state.addedType == 0
          ? Icons.feed_rounded
          : (state.addedType == 1 ? Icons.event_rounded : Icons.drive_file_rename_outline),
    ));
  }

  void changeAddedTypeTo(int id) {
    if (state.addedType != id) {
      emit(state.duplicate(
        addedType: id,
        addedIcon: state.addedType == 0
            ? Icons.feed_rounded
            : (state.addedType == 1 ? Icons.event_rounded : Icons.drive_file_rename_outline),
      ));
    }
  }

  void setSelectedTime(TimeOfDay? val) =>
      emit(state.duplicate(selectedTime: val, selectedDate: state.selectedDate ?? DateTime.now()));

  void setSelectedDate(DateTime? val) => emit(state.duplicate(selectedDate: val));

  void clearDateTime() => emit(state.duplicate(selectedDate: null, selectedTime: null));

  void _onEditEvent(Event o) {
    if (o.scheduledTime != null) {
      emit(state.duplicate(
        selectedDate: o.scheduledTime,
        selectedTime: TimeOfDay.fromDateTime(o.scheduledTime!),
      ));
    } else {
      emit(state.duplicate(selectedDate: o.scheduledTime));
    }
  }

  void addEvent(Topic topic) {
    final added = Event(
      scheduledTime: _getDateTime(),
      description: state.descriptionController!.text,
      topic: topic,
      imageName: state.imageName,
    );
    MessageRepository.add(added);
    state.descriptionController!.clear();
    emit(state.duplicate(
      selectedDate: null,
      selectedTime: null,
      imagePath: null,
      imageName: null,
    ));
  }

  void add(bool isTask, Topic topic) {
    Message added;
    if (isTask) {
      added = Task(
        description: state.descriptionController!.text,
        topic: topic,
        imageName: state.imageName,
      );
      _uploadImage();
    } else {
      added = Note(
        description: state.descriptionController!.text,
        topic: topic,
        imageName: state.imageName,
      );
    }
    MessageRepository.add(added);
    state.descriptionController!.clear();
    emit(state.duplicate(
      imagePath: null,
      imageName: null,
    ));
  }

  void finishEditing(bool isEvent) {
    final message = state.elements![state.editingIndex];
    message.description = state.descriptionController!.text;
    if (message.imageName != null && state.imageName == null) {
      StorageProvider.deleteAttachedImage(message);
    }
    message.imageName = state.imageName;
    state.descriptionController!.clear();
    _uploadImage();
    if (isEvent) {
      (message as Event).scheduledTime = _getDateTime();
      MessageRepository.updateMessage(message);
      emit(state.duplicate(
        editingFlag: false,
        selectedDate: null,
        selectedTime: null,
        imagePath: null,
        imageName: null,
      ));
    } else {
      MessageRepository.updateMessage(message);
      emit(state.duplicate(
        editingFlag: false,
        imagePath: null,
        imageName: null,
      ));
    }
  }

  DateTime? _getDateTime() {
    if (state.selectedDate != null && state.selectedTime != null) {
      return DateTime(
        state.selectedDate!.year,
        state.selectedDate!.month,
        state.selectedDate!.day,
        state.selectedTime!.hour,
        state.selectedTime!.minute,
      );
    } else if (state.selectedDate != null) {
      return DateTime(
        state.selectedDate!.year,
        state.selectedDate!.month,
        state.selectedDate!.day,
      );
    }
    return null;
  }

  void startSearch({String? toSearch}) {
    emit(state.duplicate(
      searchPage: true,
      searchController: TextEditingController()..addListener(findElements),
    ));
    if (toSearch != null) {
      state.searchController!.text = toSearch;
    }
  }

  void finishSearch() {
    emit(state.duplicate(
      searchPage: false,
      searchController: null,
      searchMessages: null,
    ));
  }

  void loadImageFromGallery() async {
    if (await Permission.storage.request().isGranted) {
      final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        emit(state.duplicate(
          imagePath: imageFile.path,
          imageName: imageFile.name,
        ));
      }
    }
  }

  void _uploadImage() {
    if (state.imagePath != null && state.imageName != null) {
      StorageProvider.uploadFile(File(state.imagePath!), state.imageName!);
    }
  }

  void removeAttachedImage() => emit(state.duplicate(imagePath: null, imageName: null));
}
