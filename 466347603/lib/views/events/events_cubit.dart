import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../modules/page_info.dart';
import '../home/home_cubit.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final Category _defaultCategory =
      const Category(icon: Icons.bubble_chart, title: '');
  final List<Category> _initCategories = const <Category>[
    Category(icon: Icons.favorite, title: 'favorite'),
    Category(icon: Icons.ac_unit, title: 'ac unit'),
    Category(icon: Icons.wine_bar, title: 'wine bar'),
    Category(icon: Icons.local_pizza, title: 'local pizza'),
    Category(icon: Icons.money, title: 'money'),
    Category(icon: Icons.car_rental, title: 'car rental'),
    Category(icon: Icons.food_bank, title: 'food bank'),
    Category(icon: Icons.navigation, title: 'navigation'),
  ];

  EventsCubit() : super(EventsState());

  void init(PageInfo page) {
    emit(
      state.copyWith(
        selectedCategory: _defaultCategory,
        page: page,
        categories:
            state.categories.isEmpty ? _initCategories : state.categories,
      ),
    );
  }

  void setEditMode(bool isEditMode) {
    emit(state.copyWith(isEditMode: isEditMode));
  }

  void setSearchMode(bool isSearchMode) {
    emit(state.copyWith(isSearchMode: isSearchMode));
  }

  bool isSearchSuggest(int index, String query) {
    if (state.page!.events[index].message == null) {
      return false;
    }
    return state.page!.events[index].message!
        .toLowerCase()
        .contains(query.toLowerCase());
  }

  void setCategory(Category category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void setReplyPage(BuildContext context, int index) {
    final page = context.read<HomeCubit>().state.pages[index];
    emit(state.copyWith(
      replyPage: page,
      replyPageIndex: index,
    ));
  }

  void setDefaultCategory() {
    emit(state.copyWith(selectedCategory: _defaultCategory));
  }

  void setMessageEdit(bool isMessageEdit) {
    emit(state.copyWith(isMessageEdit: isMessageEdit));
  }

  void unselectEvents() {
    emit(state.copyWith(selectedEvents: []));
  }

  void changeBookmarkedOnly() {
    emit(
      state.copyWith(isBookmarkedOnly: state.isBookmarkedOnly ? false : true),
    );
  }

  void selectEvent(int index) {
    var updatedSelectedEvents = List<int>.from(state.selectedEvents);
    if (state.selectedEvents.contains(index)) {
      updatedSelectedEvents.remove(index);
      if (updatedSelectedEvents.isEmpty) {
        setEditMode(false);
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
      eventsToReply.add(state.page!.events[i]);
    }
    deleteEvent();
    context.read<HomeCubit>().addEvents(eventsToReply, page!);
  }

  void copyEvent() {
    final message = state.page!.events[state.selectedEvents[0]].message;
    if (message != null) {
      Clipboard.setData(ClipboardData(text: message));
    }
    setEditMode(false);
    unselectEvents();
  }

  void bookMarkEvent() {
    var selectedEvents = List<int>.from(state.selectedEvents)..sort();
    var updatedPage = PageInfo.from(state.page!);
    for (var index in selectedEvents) {
      updatedPage.events[index].isBookmarked =
          updatedPage.events[index].isBookmarked ? false : true;
    }
    setEditMode(false);
    unselectEvents();
  }

  void deleteEvent() {
    var selectedEvents = List<int>.from(state.selectedEvents)..sort();
    var updatedPage = PageInfo.from(state.page!);
    for (var i = selectedEvents.length - 1; i >= 0; i--) {
      updatedPage.events.removeAt(selectedEvents[i]);
    }
    setEditMode(false);
    unselectEvents();
  }

  Future<void> addImageEvent() async {
    final imagePicker = ImagePicker();
    final xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      var imageFile = File(xFile.path);
      var updatedPage = PageInfo.from(state.page!)
        ..events.insert(0, Event(image: imageFile));
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
      updatedPage = state.page!..events.insert(0, Event(message: text));
      if (state.selectedCategory != _defaultCategory) {
        updatedPage.events[0].category = state.selectedCategory;
        setDefaultCategory();
      }
    }
    emit(state.copyWith(page: updatedPage));
  }

  void setHorizontalDragStart(DragStartDetails details) {
    emit(state.copyWith(xStart: details.globalPosition.dx));
  }

  void setHorizontalDragUpdate(DragUpdateDetails details) {
    emit(state.copyWith(xCurrent: details.globalPosition.dx));
  }
}
