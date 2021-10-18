import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../modules/page_info.dart';
import '../../utils/data.dart';
import '../../utils/database_provider.dart';
import '../../utils/decoder.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final Category _defaultCategory = const Category(
    icon: Icons.bubble_chart,
    title: '',
  );

  EventsCubit() : super(EventsState());

  void init(PageInfo page) async {
    final events = await DatabaseProvider.fetchEvents(page.id!);
    var lastEventMessage = '';
    if (events.isNotEmpty) {
      lastEventMessage =
          events.first.message != '' ? events.first.message! : 'ImageEvent';
    } else {
      lastEventMessage = 'No Events. Click to create one.';
    }
    page = page.copyWith(events: events);
    emit(
      state.copyWith(
        pageId: page.id,
        page: page,
        replyPage: page,
        categories:
            state.categories.isEmpty ? initCategories : state.categories,
        selectedCategory: _defaultCategory,
        showEvents: events,
        isBookmarkedOnly: false,
        lastEventMessage: lastEventMessage,
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
              event.message != null &&
              event.message!.toLowerCase().contains(query.toLowerCase()),
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

  void changeCategory(Category category) {
    if (category != _defaultCategory) {
      emit(state.copyWith(selectedCategory: category));
    }
  }

  void changeReplyPage(PageInfo page, int index) {
    emit(state.copyWith(
      replyPage: page,
      replyPageIndex: index,
    ));
  }

  void initDefaultCategory() {
    emit(state.copyWith(selectedCategory: _defaultCategory));
  }

  void changeIsMessageEdit(bool isMessageEdit) {
    emit(state.copyWith(
      isMessageEdit: isMessageEdit,
      selectedCategory: state.showEvents[state.selectedEvents[0]].category,
    ));
  }

  void unselectEvents() {
    emit(state.copyWith(selectedEvents: []));
  }

  void changeBookmarkedOnly() {
    if (state.isBookmarkedOnly) {
      emit(state.copyWith(
        showEvents: state.page!.events,
        isBookmarkedOnly: false,
      ));
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

  void replyEvents() {
    if (state.replyPage!.id == state.page!.id) {
      return;
    }
    final eventsToReply = List.generate(
      state.selectedEvents.length,
      (index) => state.showEvents[state.selectedEvents[index]],
    );
    deleteEvent();
    for (var event in eventsToReply) {
      event.pageId = state.replyPage!.id;
      DatabaseProvider.insertEvent(event);
    }
  }

  void copyEvent() {
    final message = state.showEvents[state.selectedEvents[0]].message;
    if (message != null) {
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
      DatabaseProvider.updateEvent(updatedPage.events[index]);
    }
    changeEditMode(false);
    unselectEvents();
  }

  void deleteEvent() {
    var selectedEvents = List<int>.from(state.selectedEvents)..sort();
    for (var i = selectedEvents.length - 1; i >= 0; i--) {
      DatabaseProvider.deleteEvent(state.page!.events[selectedEvents[i]]);
      state.showEvents.remove(state.page!.events[selectedEvents[i]]);
    }
    changeEditMode(false);
    unselectEvents();
  }

  Future<void> addImageEvent() async {
    final imagePicker = ImagePicker();
    final imageFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      var index = 0;
      var event;
      final imagePath = imageFile.path;
      final imageString = Decoder.base64String(
        File(imagePath).readAsBytesSync(),
      );
      if (state.newEventDate != null) {
        event = Event(
          imageString: imageString,
          pageId: state.pageId,
          sendTime: state.newEventDate,
        );
      } else {
        event = Event(
          imageString: imageString,
          pageId: state.pageId,
        );
      }
      for (var i = 0; i < state.page!.events.length; i += 1) {
        if (state.page!.events[i].sendTime!.isAfter(event.sendTime!)) {
        } else {
          index = i;
          break;
        }
      }
      DatabaseProvider.insertEvent(event);
      state.page!.events.insert(index, event);
      emit(state.copyWith(
        showEvents: state.page!.events,
        showEventsLength: state.page!.events.length,
        isBookmarkedOnly: false,
        lastEventMessage: 'Image event',
        newEventDate: null,
      ));
    }
  }

  void addMessageEvent(String text) {
    if (state.selectedEvents.length == 1 && state.isMessageEdit) {
      if (text.isNotEmpty) {
        updateEvent(text);
        if (state.selectedEvents[0] == 0) {
          emit(state.copyWith(lastEventMessage: text));
        }
      }
      emit(state.copyWith(selectedEvents: []));
    } else if (text.isNotEmpty) {
      Event event;
      var index = 0;

      if (state.newEventDate != null) {
        event = Event(
          message: text,
          pageId: state.pageId,
          sendTime: state.newEventDate,
        );
      } else {
        event = Event(
          message: text,
          pageId: state.pageId,
        );
      }
      for (var i = 0; i < state.page!.events.length; i += 1) {
        if (state.page!.events[i].sendTime!.isAfter(event.sendTime!)) {
        } else {
          index = i;
          break;
        }
      }
      if (state.selectedCategory.icon != _defaultCategory.icon) {
        event.category = state.selectedCategory;
        initDefaultCategory();
      }
      state.page!.events.insert(index, event);
      DatabaseProvider.insertEvent(event);
      emit(state.copyWith(lastEventMessage: text));
    }
    emit(state.copyWith(
      showEvents: state.page!.events,
      isBookmarkedOnly: false,
    ));
  }

  void updateEvent(String text) {
    final event = state.showEvents[state.selectedEvents[0]];
    event.message = text;
    if (state.selectedCategory != _defaultCategory) {
      event.category = state.selectedCategory;
      initDefaultCategory();
    }
    event.updateSendTime();
    state.page!.events[state.selectedEvents[0]] = event;
    DatabaseProvider.updateEvent(event);
  }

  void saveEventDate(DateTime? date, TimeOfDay? time) {
    final current = TimeOfDay.now();
    if (date != null) {
      date = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? current.hour,
        time?.minute ?? current.minute,
      );
      var eventDate =
          '${months[date.month - 1]} ${date.day}, ${date.year % 100}';
      if (time != null) {
        eventDate = '$eventDate at ${time.hour.toString().padLeft(2, '0')}:'
            '${time.minute.toString().padLeft(2, '0')}';
      }
      emit(
        state.copyWith(
          newEventDate: date,
          formattedEventDate: eventDate,
        ),
      );
    }
  }

  void changeBubbleAlignment() {
    emit(state.copyWith(
      isBubbleAlignmentRight: state.isBubbleAlignmentRight ? false : true,
    ));
  }

  void changeDateAlignment() {
    emit(state.copyWith(
      isCenterDateBubble: state.isCenterDateBubble ? false : true,
    ));
  }

  void changeDateModifiable() {
    emit(state.copyWith(
      isDateModifiable: state.isDateModifiable ? false : true,
    ));
  }
}
