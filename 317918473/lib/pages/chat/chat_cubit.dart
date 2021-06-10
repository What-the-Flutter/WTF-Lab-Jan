import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/category.dart';
import '../../models/message.dart';
import '../../repository/chat_repositore.dart';
import '../../repository/tags_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;
  final TagRepository tagRepository;
  final String categoryId;
  final List<int> _index = [];

  ChatCubit(
    this.repository,
    this.tagRepository,
    this.categoryId,
  ) : super(ChatInitial()) {
    loadData(categoryId);
  }
  Future<void> loadData(String categoryId) async {
    emit(ChatInWork(
      await repository.getAll(categoryId),
      ChatMethod.work,
      state.tag,
    ));
  }

  void addMessage(String value) {
    repository.add(value, categoryId, state.tag);
    emit(state.copyWith(message: filteringByTag(state.tag), method: ChatMethod.addMessage));
  }

  void delete(Messages messages) {
    repository.delete(messages);
    emit(ChatInWork(filteringByTag(state.tag),ChatMethod.delete,state.tag));
  }

  void favorite() {
    repository.favorite();
    repository.unselectAll();
    emit(ChatInWork(filteringByTag(state.tag),ChatMethod.favorite,state.tag));
  }

  void update(Messages messages, String message) {
    repository.update(messages, message);
    repository.unselectAll();
    emit(ChatInWork(filteringByTag(state.tag),ChatMethod.edit,state.tag));
  }

  Future<void> sendImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile != null) {
      repository.sendImage(pickedFile.path, categoryId, state.tag);
      emit(state.copyWith(
          message: filteringByTag(state.tag), method: ChatMethod.addImage));
    }
    emit(state.copyWith(
        message: filteringByTag(state.tag), method: ChatMethod.work));
  }

  void choose(Messages messages) {
    repository.select(messages);
    emit(ChatOnChoose(filteringByTag(state.tag), ChatMethod.choosed, state.tag, messages));
  }

  void select(Messages messages) {
    repository.select(messages);
    emit(ChatOnChoose(filteringByTag(state.tag), ChatMethod.select, state.tag,
        (state as ChatOnChoose).currentMessage));
  }

  void closePage() {
    repository.unselectAll();
    emit(ChatInWork(filteringByTag(state.tag), ChatMethod.close, state.tag));
  }

  void clipBoard(Messages messages) {
    Clipboard.setData(ClipboardData(text: messages.message));
    repository.unselectAll();
    emit(ChatNotifierOnSuccess(
        'Save to clipBoard', ChatMethod.clipboard, state.tag));
    emit(state.copyWith(method: ChatMethod.work));
  }

  void search(String data) {
    List<Messages> list;
    if (data.contains('img')) {
      list = repository.messages
          .where((element) => element.pathImage != null)
          .toList();
    } else {
      list = repository.messages
          .where((element) => element.message?.contains(data) ?? false)
          .toList();
    }
    emit(ChatSearchProgress(
        data == '' ? filteringByTag(state.tag) : list, ChatMethod.search, state.tag));
  }

  void sharingDone(Set<Category> list) {
    final listSelected =
        repository.messages.where((element) => element.isSelect).toList();
    for (var item in list) {
      item.repository.addMessages(listSelected);
      item.repository.unselectAll();
    }
    repository.messages.removeWhere((element) => element.isSelect);
    emit(ChatNotifierOnSuccess(
        'Sharing complete', ChatMethod.sharingComplete, state.tag));
    emit(state.copyWith(message: filteringByTag(state.tag)));
  }

  void selectTag() => emit(
      ChatChooseTagProcess(state.message, ChatMethod.selectByTag, state.tag));

  void closeTag() =>
      emit(ChatInWork(state.message, ChatMethod.work, state.tag));

  void changeTag(IconData data) {
    emit(ChatInWork(filteringByTag(data),
        ChatMethod.searchByTag, data));
  }

  List<Messages> newList(List<Messages> list) => List.from(list);

  List<Messages> filteringByTag(IconData data) => data != Icons.home ?
      repository.messages.where((element) => element.tag == data).toList() : List.from(repository.messages);
}
