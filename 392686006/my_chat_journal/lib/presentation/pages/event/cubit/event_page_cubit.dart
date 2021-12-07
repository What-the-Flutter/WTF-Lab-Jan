import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/data.dart';

import '../../../../domain/entities/category.dart';
import '../../../../domain/entities/event.dart';
import '../../../../domain/entities/event_element.dart';
import '../../home/cubit/home_page_cubit.dart';

part 'event_page_state.dart';

class EventPageCubit extends Cubit<EventPageState> {
  final Category _defaultCategory = const Category(icon: Icons.bubble_chart, title: '');

  final FocusNode messageFocusNode = FocusNode();

  final FocusNode searchFocusNode = FocusNode();

  final TextEditingController messageController = TextEditingController();

  final TextEditingController searchController = TextEditingController();

  EventPageCubit() : super(EventPageState());

  Future<void> init(Event event) async {
    messageController.addListener(_setIsAvaliableForSend);
    emit(
      state.copyWith(
        currentCategoryIndex: 0,
        event: event,
        categories: initCategories,
      ),
    );
  }

  void _setIsAvaliableForSend() {
    if (messageController.text.isEmpty) {
      emit(state.copyWith(isAvailableForSend: false));
    } else {
      emit(state.copyWith(isAvailableForSend: true));
    }
  }

  @override
  Future<void> close() {
    messageController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    messageFocusNode.dispose();
    return super.close();
  }

  void setEditMode(bool isEditMode) {
    emit(state.copyWith(isEditMode: isEditMode));
  }

  void setSearchMode(bool isSearchMode) {
    emit(state.copyWith(isSearchMode: isSearchMode));
  }

  bool isSearchSuggestion(int index, String query) {
    if (state.event!.eventElements[index].message == '') {
      return false;
    }
    return state.event!.eventElements[index].message.toLowerCase().contains(query.toLowerCase());
  }

  void setCategory(int index) {
    emit(state.copyWith(currentCategoryIndex: index));
  }

  void setReplyEventElement(BuildContext context, int index) {
    final eventElement = context.read<HomePageCubit>().state.events[index];
    emit(state.copyWith(
      replyEvent: eventElement,
      replyEventIndex: index,
    ));
  }

  void setDefaultCategory() {
    emit(state.copyWith(currentCategoryIndex: 0));
  }

  void setEventElementEdit(bool isMessageEdit) {
    emit(state.copyWith(isMessageEdit: isMessageEdit));
  }

  void unselectEventElements() {
    emit(state.copyWith(selectedEventElements: []));
  }

  void changeBookmarked() {
    emit(
      state.copyWith(isBookmarked: state.isBookmarked ? false : true),
    );
  }

  void selectEventElements(int index) {
    var updatedSelectedEvents = List<int>.from(state.selectedEventElements);
    if (state.selectedEventElements.contains(index)) {
      updatedSelectedEvents.remove(index);
      if (updatedSelectedEvents.isEmpty) {
        setEditMode(false);
      }
    } else {
      updatedSelectedEvents.add(index);
    }
    emit(state.copyWith(selectedEventElements: updatedSelectedEvents));
  }

  void replyEventElements(BuildContext context) {
    final event = state.replyEvent;
    var eventElementsToReply = <EventElement>[];
    for (var i in state.selectedEventElements) {
      eventElementsToReply.add(state.event!.eventElements[i]);
    }
    deleteEventElements();
    context.read<HomePageCubit>().fillEventWithEventElements(eventElementsToReply, event!);
  }

  void copyEventElement() {
    final message = state.event!.eventElements[state.selectedEventElements.first].message;
    if (message != '') {
      Clipboard.setData(ClipboardData(text: message));
    }
    setEditMode(false);
    unselectEventElements();
  }

  void bookMarkEventElements() {
    var selectedEvents = List<int>.from(state.selectedEventElements)..sort();
    var updatedEvent = Event.from(state.event!);
    for (var index in selectedEvents) {
      updatedEvent.eventElements[index].isBookmarked =
          updatedEvent.eventElements[index].isBookmarked ? false : true;
    }
    setEditMode(false);
    unselectEventElements();
  }

  void deleteEventElements() {
    var selectedEventElements = List<int>.from(state.selectedEventElements)..sort();
    var updatedEvent = Event.from(state.event!);
    for (var i = selectedEventElements.length - 1; i >= 0; i--) {
      updatedEvent.eventElements.removeAt(selectedEventElements[i]);
    }
    setEditMode(false);
    unselectEventElements();
  }

  Future<void> addEventElementImage() async {
    final imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      var imageFile = File(file.path);
      var updatedEvent = Event.from(state.event!)..eventElements.insert(0, EventElement(imagePath: imageFile.path));
      emit(state.copyWith(event: updatedEvent));
    }
  }

  void addEventElementMessage(String text) {
    Event? updatedEvent;
    if (state.selectedEventElements.length == 1 && state.isMessageEdit) {
      if (text.isEmpty) {
        updatedEvent = state.event!..eventElements.removeAt(state.selectedEventElements.first);
      } else {
        updatedEvent = state.event!
          ..eventElements[state.selectedEventElements.first].message = text
          ..eventElements[state.selectedEventElements.first].updateSendTime();
      }
      emit(state.copyWith(selectedEventElements: []));
    } else if (text.isNotEmpty) {
      updatedEvent = state.event!..eventElements.insert(0, EventElement(message: text));
      if (state.currentCategoryIndex != 0) {
        updatedEvent.eventElements.first.categoryId = state.currentCategoryIndex;
        setDefaultCategory();
      }
    }
    emit(state.copyWith(event: updatedEvent));
  }
}
