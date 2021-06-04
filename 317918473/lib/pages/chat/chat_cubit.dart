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
  final List<int> _index = [];

  ChatCubit(this.repository, this.tagRepository)
      : super(ChatInitial(
          repository.messages,
        ));

  void addMessage(String value) {
    repository.add(value);
    emit(ChatInWork(repository.messages, state.tag));
  }

  void delete(int index) {
    repository.delete(index);
    emit(ChatInWork(repository.messages, state.tag));
  }

  void favorite(int index) {
    repository.favorite(index);
    repository.unselectAll();
    emit(ChatInWork(newList(repository.messages), state.tag, true));
  }

  void update(int index, String message) {
    repository.update(index, message);
    repository.unselectAll();
    emit(ChatInWork(repository.messages, state.tag));
  }

  Future<void> sendImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile != null) {
      repository.sendImage(pickedFile.path);
      emit(state.copyWith(message: newList(repository.messages)));
    }
    emit(state.copyWith(message: newList(repository.messages)));
  }

  void choose(int index) {
    repository.select(index);
    emit(ChatOnChoose(repository.messages, index, state.tag));
  }

  void select(int index) {
    repository.select(index);
    if ((state as ChatOnChoose).isSelecteble) {
      emit(ChatOnChoose(newList(repository.messages),
          (state as ChatOnChoose).onChoose, state.tag, false));
    } else {
      emit(ChatOnChoose(newList(repository.messages),
          (state as ChatOnChoose).onChoose, state.tag, true));
    }
  }

  void closePage() {
    repository.unselectAll();
    emit(ChatInWork(repository.messages, state.tag));
  }

  void clipBoard(int index) {
    Clipboard.setData(ClipboardData(text: repository.messages[index].message));
    repository.unselectAll();
    emit(ChatClipBoardSuccess('Save to clipBoard', state.tag));
    emit(ChatInWork(repository.messages, state.tag));
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
    emit(
        ChatSearchProgress(data == '' ? repository.messages : list, state.tag));
  }

  void sharingDone(Set<Category> list) {
    final listSelected =
        repository.messages.where((element) => element.isSelect).toList();
    for (var item in list) {
      item.repository.addMessages(listSelected);
      item.repository.unselectAll();
    }
    repository.messages.removeWhere((element) => element.isSelect);
    emit(ChatSharingComplete(
        repository.messages, 'Sharing complete', state.tag));
    emit(state.copyWith(message: newList(repository.messages)));
  }

  void selectTag() =>
      emit(ChatChooseTagProcess(repository.messages, state.tag));

  void chooseTag(IconData icon) => emit(ChatInWork(repository.messages, icon));

  void closeTag() => emit(ChatInWork(repository.messages, state.tag));

  void onEdit(int index) => emit(ChatOnEdit(state.message, index, state.tag));

  List<Messages> newList(List<Messages> list) => List.from(list);
}
