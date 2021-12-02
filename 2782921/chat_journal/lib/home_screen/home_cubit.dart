import 'package:bloc/bloc.dart';
import 'package:chat_journal/data/database_file.dart';
import 'package:chat_journal/entity/category_page.dart';
import 'package:chat_journal/model/category.dart';
import '../model/message_data.dart';
import 'package:chat_journal/model/section.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<List<CategoryPage>> {
  // final List<Category> _titleLists = [
  //   Category(
  //     title: 'Travel',
  //     icon: const Icon(
  //       Icons.card_travel,
  //       size: 40,
  //     ),
  //     createdTime: DateTime.now(),
  //   ),
  //   Category(
  //     title: 'Family',
  //     icon: const Icon(
  //       Icons.living_rounded,
  //       size: 40,
  //     ),
  //     createdTime: DateTime.now(),
  //   ),
  //   Category(
  //     title: 'Sports',
  //     icon: const Icon(
  //       Icons.sports_mma,
  //       size: 40,
  //     ),
  //     createdTime: DateTime.now(),
  //   ),
  // ];

  DatabaseFile db = DatabaseFile();

  HomeCubit(List<CategoryPage> state) : super(state);

  void init() async {
    final pages = await db.fetchPages();
    emit(pages);
  }

  void addCategory(CategoryPage page) async {
    page.id = await db.insertPage(page);
    emit(state..add(page));
  }

  void editCategory(CategoryPage page1, CategoryPage page2) {
    page1.title = page2.title;
    page1.iconIndex = page2.iconIndex;
    db.updatePage(page1);
    final updatedCategories = List<CategoryPage>.from(state);
    emit(updatedCategories);
  }

  void deleteCategory(CategoryPage page) {
    final updatedPages = List<CategoryPage>.from(state..remove(page));
    db.deletePage(page);
    emit(updatedPages);
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
