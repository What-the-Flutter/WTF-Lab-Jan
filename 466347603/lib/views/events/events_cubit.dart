import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../modules/page_info.dart';
import '../../utils/data.dart';
import '../../utils/database.dart';
import '../home/home_cubit.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  EventsCubit() : super(EventsState());

  void init(PageInfo page) async {
    emit(state.copyWith(
      page: page,
      categories: state.categories.isEmpty ? initCategories : state.categories,
    ));
    final events = await DatabaseProvider.fetchEvents(page.id!);
    page = page.copyWith(events: events);
    emit(
      state.copyWith(
        categoryIndex: 0,
        page: page,
        replyPage: state.replyPage ?? page,
        showEvents: state.page == page
            ? state.showEvents.isEmpty
                ? page.events
                : state.showEvents
            : page.events,
      ),
    );
  }

  void changeEditMode(bool isEditMode) {
    emit(state.copyWith(isEditMode: isEditMode));
  }

  void updateSearchQuery(String query) {
    final showEvents = state.page!.events
        .where(
          (event) =>
              event.message != '' &&
              event.message.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    emit(state.copyWith(showEvents: showEvents));
  }

  void changeSearchMode(bool isSearchMode) {
    if (!isSearchMode) {
      emit(state.copyWith(showEvents: state.page!.events));
    } else {
      updateSearchQuery('');
    }
    emit(state.copyWith(isSearchMode: isSearchMode));
  }

  void changeCategory(int index) {
    emit(state.copyWith(categoryIndex: index));
  }

  void changeReplyPage(PageInfo page, int index) {
    emit(state.copyWith(
      replyPage: page,
      replyPageIndex: index,
    ));
  }

  void initDefaultCategory() {
    emit(state.copyWith(categoryIndex: 0));
  }

  void changeIsMessageEdit(bool isMessageEdit) {
    emit(state.copyWith(isMessageEdit: isMessageEdit));
  }

  void unselectEvents() {
    emit(state.copyWith(selectedEvents: []));
  }

  void changeBookmarkedOnly() {
    if (state.isBookmarkedOnly) {
      emit(state.copyWith(
          showEvents: state.page!.events, isBookmarkedOnly: false));
    } else {
      final showEvents =
          state.page!.events.where((event) => event.isBookmarked).toList();
      emit(state.copyWith(
        showEvents: showEvents,
        isBookmarkedOnly: true,
      ));
    }
  }

  void selectEvent(int index) {
    var updatedSelectedEvents = List<int>.from(state.selectedEvents);
    if (state.selectedEvents.contains(index)) {
      updatedSelectedEvents.remove(index);
      if (updatedSelectedEvents.isEmpty) {
        changeEditMode(false);
      }
    } else {
      updatedSelectedEvents.add(index);
    }
    emit(state.copyWith(selectedEvents: updatedSelectedEvents));
  }

  void replyEvents(BuildContext context) {
    final page = state.replyPage;
    var eventsToReply = <Event>[];
    for (var i in state.selectedEvents) {
      eventsToReply.add(state.showEvents[i]);
    }
    deleteEvent();
    context.read<HomeCubit>().addEvents(eventsToReply, page!);
  }

  void copyEvent() {
    final message = state.showEvents[state.selectedEvents[0]].message;
    if (message != '') {
      Clipboard.setData(ClipboardData(text: message));
    }
    changeEditMode(false);
    unselectEvents();
  }

  void bookMarkEvent() {
    var selectedEvents = List<int>.from(state.selectedEvents)..sort();
    var updatedPage = PageInfo.from(state.page!);
    for (var index in selectedEvents) {
      updatedPage.events[index].isBookmarked =
          updatedPage.events[index].isBookmarked ? false : true;
    }
    changeEditMode(false);
    unselectEvents();
  }

  void deleteEvent() {
    var selectedEvents = List<int>.from(state.selectedEvents)..sort();
    var updatedPage = PageInfo.from(state.page!);
    for (var i = selectedEvents.length - 1; i >= 0; i--) {
      updatedPage.events.removeAt(selectedEvents[i]);
      DatabaseProvider.deleteEvent(updatedPage.events[selectedEvents[i]]);
    }
    changeEditMode(false);
    unselectEvents();
  }

  Future<void> addImageEvent() async {
    final imagePicker = ImagePicker();
    final xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      var imageFile = File(xFile.path);
      var updatedPage = PageInfo.from(state.page!)
        ..events.insert(0, Event(imagePath: imageFile.path));
      DatabaseProvider.insertEvent(
          Event(imagePath: imageFile.path, pageId: state.page!.id!));
      emit(state.copyWith(page: updatedPage));
    }
  }

  void addMessageEvent(String text) {
    PageInfo? updatedPage;
    if (state.selectedEvents.length == 1 && state.isMessageEdit) {
      if (text.isEmpty) {
        updatedPage = state.page!..events.removeAt(state.selectedEvents[0]);
      } else {
        updatedPage = state.page!
          ..events[state.selectedEvents[0]].message = text
          ..events[state.selectedEvents[0]].updateSendTime();
      }
      emit(state.copyWith(selectedEvents: []));
    } else if (text.isNotEmpty) {
      updatedPage = state.page!.copyWith(
        events: List<Event>.from(state.page!.events)
          ..insert(0, Event(message: text)),
      );
      DatabaseProvider.insertEvent(
          Event(message: text, pageId: state.page!.id!));
      if (state.categoryIndex != 0) {
        updatedPage.events[0].categoryId = state.categoryIndex;
        initDefaultCategory();
      }
      emit(state.copyWith(page: updatedPage));
    }
  }
}
