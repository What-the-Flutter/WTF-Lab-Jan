import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../models/category.dart';
import '../../models/message.dart';
import '../../repository/chat_repository.dart';
import '../../repository/tags_repository.dart';
import '../../services/shared_prefs.dart';

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
      MySharedPreferences.sharedPrefs.dateTime,
      state.tag,
    ));
  }

  void addMessage(String value) async {
    final message = Messages(
      id: Uuid().v1(),
      categoryId: categoryId,
      createAt: state.dateTime,
      message: value,
      tag: state.tag,
    );
    repository.add(message);
    state.message.add(message);
    emit(state.copyWith(
      message: await filteringByTag(state.tag),
      method: ChatMethod.addMessage,
    ));
  }

  void delete() async {
    repository.delete();
    emit(ChatInWork(await filteringByTag(state.tag), ChatMethod.delete,
        state.dateTime, state.tag));
  }

  void favorite() async {
    repository.addOrRemoveToFavorite();
    emit(ChatInWork(await filteringByTag(state.tag), ChatMethod.favorite,
        state.dateTime, state.tag));
  }

  void update(Messages messages, String message) async {
    repository.update(messages.copyWith(message: message, isEdit: true));
    repository.unselectAll();
    emit(ChatInWork(await filteringByTag(state.tag), ChatMethod.edit,
        state.dateTime, state.tag));
  }

  Future<void> addImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile != null) {
      final message = Messages(
        id: Uuid().v1(),
        categoryId: categoryId,
        createAt: state.dateTime,
        pathImage: pickedFile.path,
        tag: state.tag,
      );
      repository.sendImage(message);
      emit(state.copyWith(
        message: await filteringByTag(state.tag),
        method: ChatMethod.addImage,
      ));
    }
    emit(state.copyWith(
        message: await filteringByTag(state.tag), method: ChatMethod.work));
  }

  void choose(Messages message) async {
    repository.update(message.copyWith(isSelect: !message.isSelect));
    emit(ChatOnChoose(await filteringByTag(state.tag), ChatMethod.choosed,
        state.dateTime, state.tag, message));
  }

  void select(Messages message) async {
    repository.update(message.copyWith(isSelect: !message.isSelect));
    emit(ChatOnChoose(await filteringByTag(state.tag), ChatMethod.select,
        state.dateTime, state.tag, (state as ChatOnChoose).currentMessage));
  }

  void closePage() async {
    repository.unselectAll();
    emit(ChatInWork(await filteringByTag(state.tag), ChatMethod.close,
        state.dateTime, state.tag));
  }

  void clipBoard(Messages messages) async {
    Clipboard.setData(ClipboardData(text: messages.message));
    repository.unselectAll();
    emit(ChatNotifierOnSuccess(
        'Save to clipBoard', ChatMethod.clipboard, state.dateTime, state.tag));
    emit(ChatInWork(await filteringByTag(state.tag), ChatMethod.clipboard,
        state.dateTime, state.tag));
  }

  void search(String data) async {
    List<Messages> list;
    if (data.contains('img')) {
      list =
          state.message.where((element) => element.pathImage != null).toList();
    } else {
      list = state.message
          .where((element) => element.message?.contains(data) ?? false)
          .toList();
    }
    emit(ChatSearchProgress(data == '' ? await filteringByTag(state.tag) : list,
        ChatMethod.search, state.dateTime, state.tag));
  }

  void sharingDone(Set<Category> list) async {
    for (var item in list) {
      repository.addMessages(item.id);
    }
    repository.unselectAll();
    emit(ChatNotifierOnSuccess('Sharing complete', ChatMethod.sharingComplete,
        state.dateTime, state.tag));
    emit(ChatInWork(await filteringByTag(state.tag), ChatMethod.sharingComplete,
        state.dateTime, state.tag));
  }

  void selectTag() async => emit(ChatChooseTagProcess(
      await filteringByTag(state.tag),
      ChatMethod.selectByTag,
      state.dateTime,
      state.tag));

  void closeTag() async => emit(ChatInWork(await filteringByTag(state.tag),
      ChatMethod.work, state.dateTime, state.tag));

  void changeTag(IconData data) async {
    emit(ChatInWork(await filteringByTag(data), ChatMethod.searchByTag,
        state.dateTime, data));
  }

  void setUpTime(DateTime? dateTime, TimeOfDay? timeOfDay) {
    dateTime ??= state.dateTime;
    timeOfDay ??= TimeOfDay.fromDateTime(state.dateTime);
    final dateTimeWithTimeOfDay = dateTime
        .add(Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute));
    emit(state.copyWith(dateTime: dateTimeWithTimeOfDay));
  }

  void onDismiss(Messages message) async {
    repository.update(message.copyWith(isSelect: true));
    emit(ChatOnChoose(await filteringByTag(state.tag), ChatMethod.dismiss,
        state.dateTime, state.tag, message));
  }

  List<Messages> newList(List<Messages> list) => List.from(list);

  Future<List<Messages>> filteringByTag(IconData data) async {
    final list = await repository.getAll(categoryId);
    return data != Icons.home
        ? list.where((element) => element.tag == data).toList()
        : List.from(list);
  }
}
