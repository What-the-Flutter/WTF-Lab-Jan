import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/models/message_model.dart';
import 'package:chat_journal/models/sectionicon_model.dart';
import 'package:chat_journal/screens/home_screen/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final List<Message>? _selected = [];
  final List<Message>? _favourites = [];
  final List<Message>? _foundList = [];
  final List<SectionIcon> _sectionList = [
    SectionIcon(isSelected: false, icon: Icons.clear, title: 'Cancel'),
    SectionIcon(isSelected: false, icon: Icons.fastfood, title: 'FastFood'),
    SectionIcon(isSelected: false, icon: Icons.movie, title: 'Movie'),
    SectionIcon(
        isSelected: false, icon: Icons.local_laundry_service, title: 'Laundry'),
    SectionIcon(
        isSelected: false, icon: Icons.directions_run, title: 'Running'),
    SectionIcon(
        isSelected: false, icon: Icons.sports_baseball, title: 'Sports'),
    SectionIcon(isSelected: false, icon: Icons.child_care, title: 'Child'),
    SectionIcon(isSelected: false, icon: Icons.access_alarm, title: 'Urgently'),
  ];
  late final Chat _currentChat =
      Chat(icon: null, time: null, title: '', myIndex: 0, messageBase: []);

  void init() => emit(
        state.copyWith(
          foundList: _foundList,
          sectionsList: _sectionList,
          currentChat: _currentChat,
          selected: _selected,
          favourites: _favourites,
        ),
      );

  void myInit(Chat? currChat) {
    _currentChat.messageBase = currChat!.messageBase;
    _currentChat.myIndex = currChat.myIndex;
    _currentChat.title = currChat.title;
    _currentChat.isPinned = currChat.isPinned;
    _currentChat.time = currChat.time;
    _currentChat.icon = currChat.icon;
    _updateLists();
  }

  EventCubit() : super(EventState());

  void _updateLists() {
    emit(state.copyWith(
      foundList: state.foundList,
      sectionsList: state.sectionsList,
      currentChat: state.currentChat,
      favourites: state.favourites,
      selected: state.selected,
    ));
  }

  void setIsNew (bool isNew) {
    emit(state.copyWith(isNew: isNew));
  }

  void setIsWriting (bool isWriting) {
    emit(state.copyWith(isWriting: isWriting));
  }

  void setShowPanel(bool isShowPanel) {
    emit(state.copyWith(showPanel: isShowPanel));
  }

  void setShowFav(bool isShowFav) {
    emit(state.copyWith(isShowFav: isShowFav));
  }

  void setAnySelected(bool isAnySelected) {
    emit(state.copyWith(isAnySelected: isAnySelected));
  }

  void setSearchMode(bool isSearchMode) {
    emit(state.copyWith(searchMode: isSearchMode));
  }

  void setEditMode(bool isEditMode) {
    emit(state.copyWith(editMode: isEditMode));
  }

  void cancelSelection() {
    for (var element in state.currentChat!.messageBase!) {
      if (element.isSelected == true) {
        element.isSelected = false;
      }
    }
    state.selected!.clear();
    state.selected!.isNotEmpty ? setAnySelected(true) : setAnySelected(false);
    _updateLists();
  }

  void addToFavourites() {
    for (var element in state.currentChat!.messageBase!) {
      if (element.isSelected == true) {
        element.isFavourite = !element.isFavourite;
      }
    }
    cancelSelection();
    _updateLists();
  }

  void searchMsg(String text) {
    state.foundList!.clear();
    var founded = state.currentChat!.messageBase!
        .where((element) =>
            element.message.toLowerCase().contains(text.toLowerCase()))
        .toList();
    for (var msg in founded) {
      state.foundList!.add(msg);
    }
    _updateLists();
  }

  void showFavourites() {
    state.favourites!.clear();
    var favMessages = state.currentChat!.messageBase!
        .where((element) => element.isFavourite == true)
        .toList();
    for (var element in favMessages) {
      state.favourites!.add(element);
    }
    setShowFav(!state.isShowFav!);
    _updateLists();
  }

  void setReplyCategory(BuildContext context, int index) {
    final chat = context.read<HomeCubit>().state.chatsList[index];
    emit(state.copyWith(
      replyChat: chat,
      replyChatIndex: index,
    ));
  }

  void copyMsg() {
    var buffer = '';
    for (var element in state.selected!) {
      buffer += element.message;
      buffer += '\n';
    }
    Clipboard.setData(ClipboardData(text: buffer));
  }

  void deleteMsg() {
    state.currentChat!.messageBase!
        .removeWhere((element) => element.isSelected == true);
    state.selected!.clear();
    state.selected!.isNotEmpty ? setAnySelected(true) : setAnySelected(false);
    _updateLists();
  }

  void addMsg(Message newMessage) {
    state.currentChat!.messageBase!.insert(0, newMessage);
    _updateLists();
  }

  void editMsg(String newText) {
    Message? editingMessage = state.currentChat!.messageBase!
        .firstWhere((element) => element.isSelected == true);
    editingMessage.message = newText;
    editingMessage.isSelected = false;
    var secIconIndex =
        state.sectionsList!.indexWhere((element) => element.isSelected == true);
    if (secIconIndex != -1) {
      if (editingMessage.section != state.sectionsList![secIconIndex]) {
        editingMessage.section = state.sectionsList![secIconIndex];
      }
    }
    state.selected!.clear();
    state.selected!.isNotEmpty ? setAnySelected(true) : setAnySelected(false);
    _updateLists();
  }

  void addToFavouriteOnTap(Message currentMessage) {
    var indexOfMessage =
        state.currentChat!.messageBase!.indexOf(currentMessage);
    state.currentChat!.messageBase![indexOfMessage].isFavourite =
        !state.currentChat!.messageBase![indexOfMessage].isFavourite;
    _updateLists();
  }

  void messageTools(Message currentMessage) {
    var indexOfMessage =
        state.currentChat!.messageBase!.indexOf(currentMessage);
    state.currentChat!.messageBase![indexOfMessage].isSelected =
        !state.currentChat!.messageBase![indexOfMessage].isSelected;
    state.selected!.clear();
    var selectedMessages = state.currentChat!.messageBase!
        .where((element) => element.isSelected == true)
        .toList();

    for (var element in selectedMessages) {
      state.selected!.add(element);
    }
    state.selected!.isNotEmpty ? setAnySelected(true) : setAnySelected(false);
    _updateLists();
  }

  void foundedClear() {
    state.foundList!.clear();
    _updateLists();
  }

  void uncheck() {
    for (var element in state.sectionsList!) {
      element.isSelected = false;
    }
    _updateLists();
  }

  void check(int index) {
    for (var element in state.sectionsList!) {
      element.isSelected = false;
    }
    state.sectionsList![index].isSelected = true;
    _updateLists();
  }

  void replyEvents() {
    for (var element in state.currentChat!.messageBase!) {
      if (element.isSelected == true) {
        element.isSelected = false;
      }
    }

    for (var msg in state.selected!) {
      state.replyChat!.messageBase!.add(msg);
      state.currentChat!.messageBase!.remove(msg);
    }

    cancelSelection();
    _updateLists();
  }
}
