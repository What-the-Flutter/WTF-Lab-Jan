import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../repositories/database.dart';
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
    setCategory(category);
    setCategoryListState(<Category>[]);
    setSending(false);
    setEditState(false);
    setWritingState(false);
    setMessageSelected(false);
    setEditingPhotoState(false);
    setIndexOfSelection(0);
    setIconIndex(0);
    initMessageList();
  }

  void setCategoryListState(List<Category> categories) {
    emit(
      state.copyWith(
        categories: categories,
      ),
    );
  }

  void setCategory(Category category) {
    emit(
      state.copyWith(
        category: category,
      ),
    );
  }

  void setEditState(bool isEditing) {
    emit(
      state.copyWith(
        isEditing: isEditing,
      ),
    );
  }

  void setSending(bool isSending) {
    emit(
      state.copyWith(
        isSending: isSending,
      ),
    );
  }

  void setMessageSelected(bool isSelected) {
    emit(
      state.copyWith(
        messageSelected: isSelected,
      ),
    );
  }

  void setIndexOfSelection(int indexOfSelection) {
    emit(
      state.copyWith(
        indexOfSelectedElement: indexOfSelection,
      ),
    );
  }

  void setIconIndex(int iconIndex) {
    emit(
      state.copyWith(
        iconIndex: iconIndex,
      ),
    );
  }

  void setWritingState(bool isWriting) {
    emit(
      state.copyWith(
        isWriting: isWriting,
      ),
    );
  }

  void initMessageList() async {
    emit(
      state.copyWith(
        messageList: await _databaseProvider.downloadMessageList(
          state.category!.categoryId!,
        ),
      ),
    );
  }

  void setEventState(Message message) {
    final messageStateSelected = state.messageSelected!;
    emit(
      state.copyWith(
        messageSelected: !messageStateSelected,
      ),
    );
  }

  void setEditingPhotoState(bool isSendingPhoto) {
    emit(
      state.copyWith(isSendingPhoto: isSendingPhoto),
    );
  }

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
        messageSelected: !state.messageSelected!,
      ),
    );
  }

  void deleteMessage(Message message) {
    _databaseProvider.deleteMessage(message); //todo доставать, менять , обновлять
    state.messageList.remove(message);
    final currentCategory = state.category;
    if (state.messageList.isEmpty) {
      currentCategory!.subTitleMessage = 'Add new  message';
      // нежелательно образаться к внутренним полям стэйта
    } else {
      currentCategory!.subTitleMessage =
          state.messageList[0].text; //тоже.  поля файнал вообще-то было бы неплохо.
    } //current = state.category/  copyWith обновить в emit
    emit(
      state.copyWith(
        messageList: state.messageList,
        category: currentCategory,
      ),
    );
  }

  void copyMessage(Message message) {
    Clipboard.setData(
      ClipboardData(text: state.messageList[state.indexOfSelectedElement!].text),
    );
  }

  void addMessage(String text) async {
    final message = Message(
      currentCategoryId: state.category!.categoryId!,
      time: DateFormat('yyyy-MM-dd kk:mm').format(
        DateTime.now(),
      ),
      text: text,
    );
    state.messageList.add(message);
    message.messageId = await _databaseProvider.insertMessage(message);
    state.category!.subTitleMessage = state.messageList[0].text;
    emit(
      state.copyWith(
        messageList: state.messageList,
      ),
    );
  }

  void editText(
    Message message,
    String text,
  ) {
    message.text = text;
    _databaseProvider.updateMessage(message);
    emit(
      state.copyWith(messageList: state.messageList),
    );
  }

  void setMessageText(
    Message message, //todo передавать проще к АйДи, а не целиком на уровне кьюбита
    String text,
  ) {
    message.text = text;
    emit(
      state.copyWith(
        category: state.category,
      ),
    );
  }

  void changeMessageCategory(
    int index,
    int categoryIndex,
  ) async {
    final message = Message(
      messageId: -1,
      time: DateFormat('yyyy-MM-dd kk:mm').format(
        DateTime.now(),
      ),
      text: state.messageList[index].text,
      currentCategoryId: state.category!.categoryId!,
    );
    deleteMessage(message);
    state.messageList.removeAt(index);
    message.messageId = await _databaseProvider.insertMessage(message);
    emit(
      state.copyWith(
        category: state.category,
        categories: state.categories,
      ),
    );
  }
}
