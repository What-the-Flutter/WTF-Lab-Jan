import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/models/message_model.dart';
import 'package:chat_journal/models/sectionicon_model.dart';
import 'package:chat_journal/screens/home_screen/home_cubit.dart';
import 'package:chat_journal/util/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final List<Message> _selected = [];
  final List<Message> _favourites = [];
  final List<Message> _foundList = [];
  final Chat _currentChat = Chat(
      chatIconId: -1,
      time: null,
      title: '',
      isPinned: false,
      id: -1,
      chatIcon: null,
      messageBase: []);

  Future<void> init(Chat currChat) async {
    _currentChat.id = currChat.id;
    _currentChat.isPinned = currChat.isPinned;
    _currentChat.chatIconId = currChat.chatIconId;
    _currentChat.chatIcon = currChat.chatIcon;
    _currentChat.messageBase = currChat.messageBase;
    _currentChat.title = currChat.title;
    _currentChat.time = currChat.time;
    emit(state.copyWith(
      selected: _selected,
      currentChat: _currentChat,
    ));
    emit(state.copyWith(
      sectionsList: await DBProvider.db.fetchSectionIconsList(),
    ));
  }

  EventCubit() : super(EventState());

  Future<void> _updateLists() async {
    emit(state.copyWith(
      currentChat: await DBProvider.db.fetchChatById(state.currentChat!.id),
      selected: _selected,
      foundList: _foundList,
    ));
  }

  void setIsNew(bool isNew) {
    emit(state.copyWith(isNew: isNew));
  }

  void setIsWriting(bool isWriting) {
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

  void setSelectedSection(SectionIcon? sectionIcon) {
    emit(state.copyWith(selectedSection: sectionIcon));
  }

  void cancelSelection() {
    _selected.clear();
    _selected.isNotEmpty ? setAnySelected(true) : setAnySelected(false);
    _updateLists();
  }

  Future<void> addToFavourites() async {
    for (var sel in _selected) {
      for (var msg in state.currentChat!.messageBase) {
        if (msg == sel) {
          msg.isFavourite = !msg.isFavourite;
          await DBProvider.db.updateMessage(msg);
        }
      }
    }
    cancelSelection();
  }

  Future<void> searchMsg(String text) async {
    _foundList.clear();
    final founded =
        await DBProvider.db.searchMessages(state.currentChat!.id, text);
    for (var msg in founded) {
      _foundList.add(msg);
    }
    emit(state.copyWith(foundList: _foundList));
  }

  Future<void> showFavourites() async {
    _favourites.clear();
    final favourites = await DBProvider.db.fetchFavouriteMessages();
    for (var msg in favourites) {
      _favourites.add(msg);
    }
    emit(state.copyWith(favourites: _favourites));
    setShowFav(!state.isShowFav!);
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
    for (var element in _selected) {
      buffer += element.message;
      buffer += '\n';
    }
    Clipboard.setData(ClipboardData(text: buffer));
  }

  Future<void> deleteMsg() async {
    for (var sel in _selected) {
      await DBProvider.db.deleteMessage(sel);
    }

    cancelSelection();
  }

  Future<void> addMsg(Message newMessage) async {
    await DBProvider.db.insertMessage(newMessage);
    _updateLists();
  }

  Future<void> editMsg(String newText) async {
    Message? editingMessage = _selected[0];
    editingMessage.message = newText;
    if (state.selectedSection!.id != -1) {
      editingMessage.sectionIconId = state.selectedSection!.id;
    }
    await DBProvider.db.updateMessage(editingMessage);
    _selected.clear();
    _selected.isNotEmpty ? setAnySelected(true) : setAnySelected(false);
    _updateLists();
  }

  Future<void> addToFavouriteOnTap(Message currentMessage) async {
    final curMsg = currentMessage;
    curMsg.isFavourite = !curMsg.isFavourite;
    await DBProvider.db.updateMessage(curMsg);
    cancelSelection();
    _updateLists();
  }

  void messageTools(Message currentMessage) {
    if (_selected.contains(currentMessage)) {
      _selected.remove(currentMessage);
    } else {
      _selected.add(currentMessage);
    }
    _selected.isNotEmpty ? setAnySelected(true) : setAnySelected(false);
  }

  void foundedClear() {
    _foundList.clear();
    _updateLists();
  }

  Future<void> replyEvents() async {
    for (var msg in state.selected) {
      msg.chatId = state.replyChat!.id;
      await DBProvider.db.updateMessage(msg);
    }

    cancelSelection();
    _updateLists();
  }
}
