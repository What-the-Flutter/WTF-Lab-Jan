import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/models/message_model.dart';
import 'package:chat_journal/models/sectionicon_model.dart';
import 'package:chat_journal/screens/home_screen/home_cubit.dart';
import 'package:chat_journal/util/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit()
      : super(EventState(
          currentChat: Chat(
            time: null,
            chatIconTitle: '',
            title: '',
            isPinned: false,
            id: '',
            lastMessage: '',
            lastMessageTime: null,
          ),
        ));

  Future<void> init(Chat currChat) async {
    emit(state.copyWith(
      currentChat: currChat,
      sectionsList: await DBProvider.db.fetchSectionIconsList(),
      messageBase: await DBProvider.db.fetchMessagesList(currChat.id!),
    ));
  }

  Future<void> setMessageList(Map<dynamic, dynamic> map) async {
    final Map<dynamic, dynamic> values = map;
    final messageList = <Message>[];
    values.forEach((key, value) async {
      final message = Message.fromMap(key, value);
      messageList.insert(0, message);
    });
    emit(state.copyWith(messageBase: messageList));
  }

  Future<void> _updateMessageList(List<Message> messageList) async {
    emit(state.copyWith(
      messageBase: messageList,
    ));
  }

  void _updateSelectedList(List<Message> sel) {
    emit(state.copyWith(selected: sel));
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
    emit(state.copyWith(
      selectedSection: sectionIcon,
    ));
  }

  void cancelSelection() {
    List<Message> sel = state.selected.toList();
    sel.clear();
    _updateSelectedList(sel);
    state.selected.isNotEmpty ? setAnySelected(true) : setAnySelected(false);
  }

  Future<void> addToFavourites() async {
    List<Message> messages = state.messageBase!.toList();
    final favourites = <Message>[];
    for (var sel in state.selected) {
      for (var msg in messages) {
        if (msg == sel) {
          msg.isFavourite = !msg.isFavourite;
          favourites.add(msg);
        }
      }
    }
    _updateMessageList(messages);
    for (var fav in favourites) {
      await DBProvider.db.updateMessage(fav, state.currentChat!.id!);
    }
    cancelSelection();
  }

  Future<void> searchMsg(String text) async {
    List<Message> myFounded = state.foundList.toList();
    myFounded.clear();

    for (var msg in state.messageBase!) {
      if (msg.message.contains(text)) {
        myFounded.add(msg);
      }
    }

    emit(state.copyWith(foundList: myFounded));
  }

  Future<void> showFavourites() async {
    List<Message> myFavourites = state.favourites.toList();
    myFavourites.clear();

    for (var msg in state.messageBase!) {
      if (msg.isFavourite == true) {
        myFavourites.add(msg);
      }
    }

    emit(state.copyWith(favourites: myFavourites));
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
    for (var element in state.selected) {
      buffer += element.message;
      buffer += '\n';
    }
    Clipboard.setData(ClipboardData(text: buffer));
  }

  Future<void> deleteMsg() async {
    List<Message> messages = state.messageBase!.toList();
    for (var sel in state.selected) {
      messages.remove(sel);
    }
    _updateMessageList(messages);

    for (var sel in state.selected) {
      await DBProvider.db.deleteMessage(sel, state.currentChat!.id!);
    }

    final currChat = state.currentChat;
    if (state.messageBase!.isNotEmpty) {
      currChat!.lastMessage = state.messageBase!.first.message;
      currChat.lastMessageTime = state.messageBase!.first.time;
    } else {
      currChat!.lastMessage = 'No events. Click to create one';
      currChat.lastMessageTime = null;
    }
    await DBProvider.db.updateChat(currChat);
    cancelSelection();
  }

  Future<void> addMsg(Message newMessage) async {
    List<Message> messages = state.messageBase!.toList();
    messages.insert(0, newMessage);
    _updateMessageList(messages);
    await DBProvider.db.insertMessage(newMessage, state.currentChat!.id!);
    final currChat = state.currentChat;
    currChat!.lastMessage = newMessage.message;
    currChat.lastMessageTime = newMessage.time;
    await DBProvider.db.updateChat(currChat);
  }

  Future<void> editMsg(String newText) async {
    List<Message> messages = state.messageBase!.toList();
    Message? editingMessage = state.selected[0];
    editingMessage.message = newText;
    if (state.selectedSection!.iconTitle != 'work') {
      editingMessage.sectionIconTitle = state.selectedSection!.iconTitle;
      editingMessage.sectionName = state.selectedSection!.title;
    }
    for (var message in messages) {
      if (message == state.selected[0]) {
        message = editingMessage;
      }
    }
    _updateMessageList(messages);

    await DBProvider.db.updateMessage(editingMessage, state.currentChat!.id!);

    if (state.selected[0] == state.messageBase!.first) {
      final currChat = state.currentChat;
      currChat!.lastMessage = editingMessage.message;
      currChat.lastMessageTime = editingMessage.time;
      await DBProvider.db.updateChat(currChat);
    }

    cancelSelection();
  }

  Future<void> addToFavouriteOnTap(Message currentMessage) async {
    final curMsg = currentMessage;
    curMsg.isFavourite = !curMsg.isFavourite;
    List<Message> messages = state.messageBase!.toList();
    for (var message in messages) {
      if (message == currentMessage) {
        message = curMsg;
      }
    }
    _updateMessageList(messages);
    await DBProvider.db.updateMessage(curMsg, state.currentChat!.id!);
    cancelSelection();
  }

  void messageTools(Message currentMessage) {
    List<Message> sel = state.selected.toList();
    if (state.selected.contains(currentMessage)) {
      sel.remove(currentMessage);
    } else {
      sel.add(currentMessage);
    }
    _updateSelectedList(sel);
    state.selected.isNotEmpty ? setAnySelected(true) : setAnySelected(false);
  }

  void foundedClear() {
    List<Message> founded = state.foundList.toList();
    founded.clear();
  }

  Future<void> replyEvents() async {
    List<Message> messages = state.messageBase!.toList();
    for (var sel in state.selected) {
      messages.remove(sel);
    }
    _updateMessageList(messages);
    for (var msg in state.selected) {
      await DBProvider.db.insertMessage(msg, state.replyChat!.id!);
      await DBProvider.db.deleteMessage(msg, state.currentChat!.id!);
    }

    final currChat = state.currentChat;
    if (state.messageBase!.isNotEmpty) {
      currChat!.lastMessage = state.messageBase!.first.message;
      currChat.lastMessageTime = state.messageBase!.first.time;
    } else {
      currChat!.lastMessage = 'No events. Click to create one';
      currChat.lastMessageTime = null;
    }

    await DBProvider.db.updateChat(currChat);
    cancelSelection();
  }
}
