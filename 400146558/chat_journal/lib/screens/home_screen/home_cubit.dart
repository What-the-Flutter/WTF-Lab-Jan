import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final List<Chat> _chatsList = <Chat>[
    Chat(
      icon: Icons.airplanemode_on_sharp,
      myIndex: 0,
      title: 'Travel',
      messageBase: <Message>[
        Message(
            "buy bread",
            Jiffy({
              "year": 2021,
              "month": 9,
              "day": 20,
              "hour": 14,
              "minutes": 45
            }),
            false,
            false,
            null),
        Message(
            "go to school",
            Jiffy({
              "year": 2021,
              "month": 9,
              "day": 20,
              "hour": 14,
              "minutes": 50
            }),
            false,
            false,
            null),
        Message(
            "go to work",
            Jiffy({
              "year": 2021,
              "month": 9,
              "day": 20,
              "hour": 14,
              "minutes": 53
            }),
            false,
            false,
            null),
      ],
      time: Jiffy(
          {"year": 2021, "month": 9, "day": 20, "hour": 14, "minutes": 45}),
    ),
    Chat(
      icon: Icons.book_rounded,
      myIndex: 1,
      title: 'Journal',
      messageBase: [],
      time: Jiffy(
          {"year": 2021, "month": 9, "day": 20, "hour": 14, "minutes": 45}),
    ),
    Chat(
      icon: Icons.nature_people,
      myIndex: 2,
      title: 'Communication',
      messageBase: [],
      time: Jiffy(
          {"year": 2021, "month": 9, "day": 20, "hour": 14, "minutes": 45}),
    ),
  ];

  HomeCubit() : super(HomeState());

  void init() => emit(state.copyWith(chatsList: _chatsList));

  void _updateChatsList() {
    emit(state.copyWith(chatsList: state.chatsList));
  }

  void pinChat(int index) {
    var _chosenChat = deleteChat(index);
    if (_chosenChat.isPinned == false) {
      var _indexLastPinned =
          state.chatsList.lastIndexWhere((element) => element.isPinned == true);
      _indexLastPinned == -1
          ? state.chatsList.insert(0, _chosenChat)
          : state.chatsList.insert(_indexLastPinned + 1, _chosenChat);
      _chosenChat.isPinned = true;
    } else {
      state.chatsList.insert(_chosenChat.myIndex, _chosenChat);
      _chosenChat.isPinned = false;
    }
    _updateChatsList();
  }

  void addChat(Chat chat) {
    var newChat = chat;
    chat.myIndex = state.chatsList.length;
    state.chatsList.add(newChat);
    _updateChatsList();
  }

  Chat deleteChat(int index) {
    var delChat = state.chatsList.removeAt(index);
    _updateChatsList();
    return delChat;
  }

  void editChat(int index, Chat chat) {
    state.chatsList[index] = chat;
    _updateChatsList();
  }
//
// void addEvents(List<Event> events, Category category) {
//   final categories = List<Category>.from(state.categoryList);
//   final index = categories.indexOf(category);
//   for (var event in events) {
//     categories[index].eventList.add(event);
//   }
//   emit(state.copyWith(categoryList: categories));
// }
}
