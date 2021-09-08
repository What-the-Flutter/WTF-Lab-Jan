import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/note_model.dart';
import '../home_screen/home_cubit.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final EventCategory _defaultCategory =
  const EventCategory(icon: null, title: '');

  EventCubit() : super(EventState());

  void init(PageCategoryInfo note) {
    emit(state.copyWith(
      pageNote: note,
    ));
  }

  void setEditMode(bool isEditMode){
    emit(state.copyWith(
      isEditMode: isEditMode,
    ));
  }

  void setMessageEditMode(bool isMessageEdit) {
    emit(state.copyWith(isTextEditMode: isMessageEdit));
  }

  void setCategory(EventCategory category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void setReplyPage(BuildContext context, int index) {
    final page = context.read<HomeCubit>().state.pages[index];
    emit(state.copyWith(
      pageToReply: page,
      pageReplyIndex: index,
    ));
  }

  void setDefaultCategory() {
    emit(state.copyWith(selectedCategory: _defaultCategory));
  }

  void setIsChangingCategory() {
    emit(state.copyWith(isChangingCategory: !state.isChangingCategory));
  }

  void unselectEvents() {
    emit(state.copyWith(activeNotes: []));
  }

  void selectEvent(int index) {
    var updatedSelectedEvents = List<int>.from(state.activeNotes);
    if (state.activeNotes.contains(index)) {
      updatedSelectedEvents.remove(index);
      if (updatedSelectedEvents.isEmpty) {
        setEditMode(false);
      }
    } else {
      updatedSelectedEvents.add(index);
    }
    emit(state.copyWith(activeNotes: updatedSelectedEvents));
  }

  void replyEvents(BuildContext context) {
    final page = state.pageToReply;
    var eventsToReply = <Note>[];
    for (var i in state.activeNotes) {
      eventsToReply.add(state.pageNote!.note[i]);
    }
    deleteEvent();
    context.read<HomeCubit>().addEvents(eventsToReply, page!);
  }

  void copyDataFromEvents() {
    final message = state.pageNote!.note[state.activeNotes[0]].description;
    if (message != null) {
      Clipboard.setData(ClipboardData(text: message));
    }
    setEditMode(false);
    unselectEvents();
  }

  void addMessageEvent(String text) {
    PageCategoryInfo? updatedPage;
    if (state.activeNotes.length == 1 && state.isTextEditMode) {
      if (text.isEmpty) {
        updatedPage = state.pageNote!..note.removeAt(state.activeNotes[0]);
      } else {
        updatedPage = state.pageNote!
          ..note[state.activeNotes[0]].description = text
          ..note[state.activeNotes[0]].updateSendTime();
      }
      emit(state.copyWith(activeNotes: []));
    } else if (text.isNotEmpty) {
      updatedPage = state.pageNote!..note.insert(0, Note(description: text));
      if (state.selectedCategory != _defaultCategory) {
        updatedPage.note[0].category = state.selectedCategory;
        setDefaultCategory();
      }
    }
    emit(state.copyWith(pageNote: updatedPage));
  }

  void deleteEvent() {
    var activeNotes = List<int>.from(state.activeNotes)..sort();
    var updatedPage = PageCategoryInfo.from(state.pageNote!);
    for (var i = activeNotes.length - 1; i >= 0; i--) {
      updatedPage.note.removeAt(activeNotes[i]);
    }
    setEditMode(false);
    unselectEvents();
  }

}
