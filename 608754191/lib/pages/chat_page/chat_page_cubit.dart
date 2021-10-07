import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_wtf/util/database.dart';

import '../entity/category.dart';
import '../entity/message.dart';
import 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  final DatabaseProvider _databaseProvider = DatabaseProvider();
  ChatPageCubit()
      : super(
          ChatPageState(),
        );

  void init(Category category) {
    setNote(category);
    setCategoryListState(<Category>[]);
    setSending(false);
    setEditState(false);
    setMessageSelected(false);
    setIndexOfSelection(0);
    setIconIndex(0);
    initMessageList();
  }

  void setCategoryListState(List<Category> categories) =>
      emit(state.copyWith(categories: categories));

  void setNote(Category category) => emit(state.copyWith(category: category));

  void setEditState(bool isEditing) {
    emit(
      state.copyWith(isEditing: isEditing),
    );
  }

  void setSending(bool isSending) {
    emit(
      state.copyWith(isSending: isSending),
    );
  }

  void setMessageSelected(bool isSelected) {
    emit(
      state.copyWith(messageSelected: isSelected),
    );
  }

  void setIndexOfSelection(int indexOfSelection) {
    emit(
      state.copyWith(indexOfSelectedElement: indexOfSelection),
    );
  }

  void setIconIndex(int iconIndex) {
    emit(
      state.copyWith(iconIndex: iconIndex),
    );
  }

  void initMessageList() async {
    emit(state.copyWith(
      messageList: await _databaseProvider.downloadMessageList(state.category!.categoryId),
    ));
  }

  // void setEventState(Message message) {
  //   message.isSelected = !message.isSelected;
  //   emit(state.copyWith(message: message));
  // }

  void changeIndexOfSelectedElement(int index) {
    emit(
      state.copyWith(
        indexOfSelectedElement: index,
      ),
    );
  }

  void swapAppBar() {
    emit(
      state.copyWith(
        messageSelected: state.messageSelected,
      ),
    );
  }

  void deleteMessage(Message message) {
    _databaseProvider.deleteMessage(message);
    state.messageList!.remove(message);
    if (state.messageList!.isEmpty) {
      state.category!.subTitleMessage = 'add new message';
    } else {
      state.category!.subTitleMessage = state.messageList![0].text;
    }
    emit(
      state.copyWith(messageList: state.messageList),
    );
  }

  void copyMessages(Message message) {
    Clipboard.setData(
      ClipboardData(text: state.message!.text),
    );
    emit(
      state.copyWith(category: state.category),
    );
  }

  void addMessage(String text) {
    final message = Message(
      messageId: 0,
      currentCategoryId: state.category!.categoryId,
      iconIndex: state.iconIndex ?? state.iconIndex!,
      time: DateFormat.yMMMd().format(DateTime.now()),
      text: text,
    );
    state.messageList!.insert(0, message);
    emit(
      state.copyWith(category: state.category),
    );
  }

  void editText(Message message, String text) {
    message.text = text;
    _databaseProvider.updateMessage(message);
    emit(
      state.copyWith(category: state.category),
    );
  }

  void setMessageText(Message message, String text) {
    message.text = text;
    emit(
      state.copyWith(category: state.category),
    );
  }

  // void changeMessageCategory(int index, int categoryIndex) {
  //   state.categories[categoryIndex].listMessages.insert(
  //     0,
  //     Message(
  //       messageId: 1,
  //       time: DateTime.now(),
  //       text: state.category.listMessages[index].text,
  //     ),
  //   );
  //   state.category.listMessages.removeAt(index);
  //   emit(
  //     state.copyWith(category: state.category, categories: state.categories),
  //   );
  // }
}
