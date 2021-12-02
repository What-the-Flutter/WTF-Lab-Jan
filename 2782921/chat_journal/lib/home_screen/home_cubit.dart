import 'package:bloc/bloc.dart';
import 'package:chat_journal/model/category.dart';
import '../model/message_data.dart';
import 'package:chat_journal/model/section.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final List<Category> _titleLists = [
    Category(
      title: 'Travel',
      icon: const Icon(
        Icons.card_travel,
        size: 40,
      ),
      createdTime: DateTime.now(),
    ),
    Category(
      title: 'Family',
      icon: const Icon(
        Icons.living_rounded,
        size: 40,
      ),
      createdTime: DateTime.now(),
    ),
    Category(
      title: 'Sports',
      icon: const Icon(
        Icons.sports_mma,
        size: 40,
      ),
      createdTime: DateTime.now(),
    ),
  ];

  HomeCubit() : super(HomeState());

  void init() => emit(
        state.copyWith(categories: _titleLists),
      );

  void addCategory(Category list) {
    state.categories.add(list);
    emit(state.copyWith(categories: state.categories));
    print(state.toString());
  }

  void editCategory(Category list, int index) {
    state.categories[index] = list;
    emit(state.copyWith(categories: state.categories));
    print(state.toString());
  }

  void deleteCategory(int index) {
    state.categories.removeAt(index);
    emit(state.copyWith(categories: state.categories));
  }

  void addMessage(String text, int index) {
    var message = MessageData(mText: text, datetime: DateTime.now());
    state.categories[index].message!.add(message);
    emit(state);
  }

  void messageLike(MessageData message, int index1, int index2) {
    message.liked = !message.liked;
    emit(state.copyWith(categories: state.categories));
  }

  void editEvent(int indexMessage, String messageText, int intCategory) {
    state.categories[intCategory].message![indexMessage].mText = messageText;
    state.categories[intCategory].message![indexMessage].datetime =
        DateTime.now();
    emit(state.copyWith(categories: state.categories));
  }

  void deleteMessage(int intCategory, int indexMessage) {
    state.categories[intCategory].message!.removeAt(indexMessage);
    emit(state.copyWith(categories: state.categories));
  }

  void setSection(Section section, int index, int messageindex) {
    state.categories[index].message![messageindex].section = section;
    emit(state.copyWith(categories: state.categories));
  }

//copywith
  void migrateMessage(
    MessageData data,
    int indexCategoryTo,
  ) {
    state.categories[indexCategoryTo].message!.add(data);

    emit(state.copyWith(categories: state.categories, index: indexCategoryTo));
  }

  // Stream<List<MessageData>?> addMessage(
  //     Category list, MessageData data) async* {
  //   list.message!.add(data);
  //   yield list.message;
  // }
}
