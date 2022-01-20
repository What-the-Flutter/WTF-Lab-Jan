import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '/models/chat_model.dart';
import '/models/event_model.dart';
part 'chat_screen_state.dart';

class ChatScreenCubit extends Cubit<ChatScreenState> {
  ChatScreenCubit() : super(ChatScreenState());

  void setMessages(int selectedChatIndex) => emit(
        state.copyWith(eventList: chatList[selectedChatIndex].eventList),
      );

  void changeParameters({
    bool? isEmpty,
    bool? isEdit,
    bool? isShowFavorites,
    bool? isSearching,
    bool? isCategoriesOpened,
    int? selectedItemsCount,
    List<Event>? eventList,
  }) =>
      emit(
        state.copyWith(
          isTextFieldEmpty: isEmpty,
          isEditing: isEdit,
          isShowFavorites: isShowFavorites,
          isSearching: isSearching,
          isCategoriesOpened: isCategoriesOpened,
          selectedItemsCount: selectedItemsCount,
          eventList: eventList,
        ),
      );

  void addImage(int i) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    chatList[i].eventList.insert(
          0,
          Event(
            key: UniqueKey(),
            text: 'Image Entry',
            imagePath: image.path,
            date: DateTime.now(),
          ),
        );
    emit(state.copyWith(eventList: chatList[i].eventList));
  }

  void onTap(int chatIndex, int eventIndex) {
    var _itemsCount = state.selectedItemsCount;
    if (state.eventList[eventIndex].isSelected ||
        state.selectedItemsCount > 0) {
      state.eventList[eventIndex] = state.eventList[eventIndex]
          .copyWith(isSelected: !state.eventList[eventIndex].isSelected);
      state.eventList[eventIndex].isSelected
          ? emit(state.copyWith(
              selectedItemsCount: ++_itemsCount,
              eventList: state.eventList,
            ))
          : emit(state.copyWith(
              selectedItemsCount: --_itemsCount,
              eventList: state.eventList,
            ));
    } else {
      state.eventList[eventIndex] = state.eventList[eventIndex]
          .copyWith(isFavorite: !state.eventList[eventIndex].isFavorite);
      emit(state.copyWith(eventList: state.eventList));
    }
  }

  void onLongPress(int chatIndex, int eventIndex) {
    state.eventList[eventIndex] = state.eventList[eventIndex]
        .copyWith(isSelected: !state.eventList[eventIndex].isSelected);
    state.eventList[eventIndex].isSelected
        ? emit(
            state.copyWith(
              selectedItemsCount: state.selectedItemsCount + 1,
              eventList: state.eventList,
            ),
          )
        : emit(
            state.copyWith(
              selectedItemsCount: state.selectedItemsCount - 1,
              eventList: state.eventList,
            ),
          );
  }

  void copyText(int chatIndex) {
    var selectedStringElements = '';
    for (var i = chatList[chatIndex].eventList.length; i > 0; i--) {
      if (chatList[chatIndex].eventList[i - 1].isSelected) {
        selectedStringElements +=
            '${chatList[chatIndex].eventList[i - 1].text}\n';
      }
    }
    selectedStringElements =
        selectedStringElements.substring(0, selectedStringElements.length - 1);
    Clipboard.setData(ClipboardData(text: selectedStringElements));
    emit(state.copyWith(selectedItemsCount: 0));
    unselectElements(chatIndex);
  }

  void addNewEvent(String text, int i) {
    chatList[i].eventList.insert(
          0,
          Event(
            key: UniqueKey(),
            text: text
                .split(RegExp(r'(?:\r?\n|\r)'))
                .where((s) => s.trim().isNotEmpty)
                .join('\n'),
            date: DateTime.now(),
          ),
        );
    emit(state.copyWith(
      eventList: chatList[i].eventList,
      isTextFieldEmpty: true,
    ));
  }

  void deleteElement(int selectedChatIndex, {UniqueKey? key}) {
    var _messagessList = [];
    for (var element in chatList[selectedChatIndex].eventList) {
      if (element.isSelected || key == element.key) {
        _messagessList.add(element);
      }
    }

    chatList[selectedChatIndex]
        .eventList
        .removeWhere((e) => _messagessList.contains(e));
    emit(
      state.copyWith(
        selectedItemsCount: 0,
        eventList: chatList[selectedChatIndex].eventList,
      ),
    );
  }

  void addSelectedToFavorites(int selectedChatIndex) {
    for (var i = 1; i <= chatList[selectedChatIndex].eventList.length; i++) {
      if (chatList[selectedChatIndex].eventList[i - 1].isSelected) {
        chatList[selectedChatIndex].eventList[i - 1] =
            chatList[selectedChatIndex].eventList[i - 1].copyWith(
                  isFavorite:
                      !chatList[selectedChatIndex].eventList[i - 1].isFavorite,
                );
      }
    }
    unselectElements(selectedChatIndex);
  }

  void unselectElements(int selectedChatIndex) {
    for (var i = 0;
        i <= chatList[selectedChatIndex].eventList.length - 1;
        i++) {
      if (chatList[selectedChatIndex].eventList[i].isSelected) {
        chatList[selectedChatIndex].eventList[i] = chatList[selectedChatIndex]
            .eventList[i]
            .copyWith(isSelected: false);
      }
    }

    emit(
      state.copyWith(
        selectedItemsCount: 0,
        eventList: chatList[selectedChatIndex].eventList,
      ),
    );
  }

  // void editMessageText(
  //   int selectedChatIndex,
  //   TextEditingController controller,
  //   UniqueKey? key,
  // ) {
  //   for (var element in chatList[selectedChatIndex].eventList) {
  //     if (element.isSelected) {
  //       key = element.key;
  //       controller.text = element.text;
  //       controller.selection = TextSelection.fromPosition(
  //         TextPosition(offset: controller.text.length),
  //       );
  //       break;
  //     }
  //   }
  //   emit(state.copyWith(isEditing: true));
  //   unselectElements(selectedChatIndex);
  // }

  void showAllFavorites(int index) {
    emit(state.copyWith(isShowFavorites: !state.isShowFavorites));
    if (state.isShowFavorites) {
      emit(
        state.copyWith(
          eventList: chatList[index]
              .eventList
              .where((element) => element.isFavorite)
              .toList(),
        ),
      );
    } else {
      emit(state.copyWith(eventList: chatList[index].eventList));
    }
  }

  void searchingEventElements(int index, String value) {
    var newList = chatList[index]
        .eventList
        .where(
          (element) => element.text.toLowerCase().contains(
                value.toLowerCase(),
              ),
        )
        .toList();
    if (value == '') newList = [];
    emit(state.copyWith(eventList: newList));
  }

  void moveMessageToAnotherChat(int newChatIndex, int oldChatIndex) {
    if (newChatIndex == oldChatIndex) return;
    for (var i = 0; i <= chatList[oldChatIndex].eventList.length - 1; i++) {
      if (chatList[oldChatIndex].eventList[i].isSelected) {
        chatList[newChatIndex]
            .eventList
            .add(chatList[oldChatIndex].eventList[i]);
      }
    }
    unselectElements(newChatIndex);
    chatList[oldChatIndex]
        .eventList
        .removeWhere((element) => element.isSelected);
    emit(
      state.copyWith(
        eventList: chatList[oldChatIndex].eventList,
        selectedItemsCount: 0,
      ),
    );
  }

  void setCategory(String text, IconData icon) {
    if (text == 'Cansel') {
      emit(state.copyWith(
        isCategoriesOpened: false,
        categoryIcon: Icons.close,
        categoryName: 'Close',
      ));
    } else {
      emit(state.copyWith(
        isCategoriesOpened: false,
        categoryName: text,
        categoryIcon: icon,
      ));
    }
  }

  void addEventWithCategory(
    int i,
    String text,
  ) {
    chatList[i].eventList.insert(
          0,
          Event(
            text: text == '' ? state.categoryName : text,
            date: DateTime.now(),
            key: UniqueKey(),
            categoryName: state.categoryName,
            categoryIcon: state.categoryIcon,
          ),
        );
    emit(state.copyWith(
      eventList: chatList[i].eventList,
      isTextFieldEmpty: true,
      categoryIcon: Icons.close,
      categoryName: 'Close',
    ));
  }
}
