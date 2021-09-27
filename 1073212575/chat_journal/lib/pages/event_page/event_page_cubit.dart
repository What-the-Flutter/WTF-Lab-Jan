import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';

import '../../models/events.dart';
import 'event_page_state.dart';

class EventPageCubit extends Cubit<EventPageState> {
  EventPageCubit()
      : super(
          EventPageState(
            messages: [],
            onlyMarked: false,
            isSelected: false,
            isSearchGoing: false,
            isCategoryPanelOpened: false,
            needsEditing: false,
            selectedMessageIndex: -1,
            categoryIcon: null,
          ),
        );

  void startSearching() {
    emit(
      state.copyWith(
        messages: [],
        isSearchGoing: true,
      ),
    );
  }

  void endSearching(
    int eventPageIndex,
    TextEditingController searchController,
  ) {
    emit(
      state.copyWith(
        messages: eventPages[eventPageIndex].eventMessages,
        isSearchGoing: false,
        categoryIcon: null,
      ),
    );
    searchController.clear();
  }

  void searchMessages(int eventPageIndex, String text) {
    text.toLowerCase();
    emit(
      state.copyWith(
        messages: eventPages[eventPageIndex]
            .eventMessages
            .where((message) =>
                message.content.toString().toLowerCase().contains(text) &&
                message.content.toString() != "Instance of 'XFile'")
            .toList(),
      ),
    );
  }

  void unselect() {
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  void mark(int i, int eventPageIndex) {
    if (eventPages[eventPageIndex].eventMessages[i].isMarked == false) {
      eventPages[eventPageIndex].eventMessages[i].isMarked = true;
    } else {
      eventPages[eventPageIndex].eventMessages[i].isMarked = false;
    }
  }

  void showMarked(int eventPageIndex) {
    if (state.onlyMarked) {
      emit(
        state.copyWith(
          messages: eventPages[eventPageIndex]
              .eventMessages
              .where((message) => message.isMarked == true)
              .toList(),
          onlyMarked: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          messages: eventPages[eventPageIndex].eventMessages,
          onlyMarked: true,
        ),
      );
    }
  }

  void showMessages(int eventPageIndex) {
    emit(
      state.copyWith(
        messages: eventPages[eventPageIndex].eventMessages,
        onlyMarked: false,
      ),
    );
  }

  void delete(int eventPageIndex, [int messageIndex = -1]) {
    if (messageIndex == -1) {
      messageIndex = state.selectedMessageIndex;
    }
    eventPages[eventPageIndex].eventMessages.removeAt(messageIndex);
    emit(
      state.copyWith(
        messages: eventPages[eventPageIndex].eventMessages,
        isSelected: false,
      ),
    );
  }

  void edit(int eventPageIndex, TextEditingController controller,
      [int messageIndex = -1]) {
    if (messageIndex == -1) {
      messageIndex = state.selectedMessageIndex;
    }
    if (eventPages[eventPageIndex]
            .eventMessages[messageIndex]
            .content
            .toString() ==
        "Instance of 'XFile'") {
      addImage(eventPageIndex);
    } else {
      controller.text =
          eventPages[eventPageIndex].eventMessages[messageIndex].content;
    }
    emit(state.copyWith(
      needsEditing: true,
      selectedMessageIndex: messageIndex,
    ));
  }

  void copy(int eventPageIndex) {
    Clipboard.setData(
      ClipboardData(
          text: eventPages[eventPageIndex]
              .eventMessages[state.selectedMessageIndex]
              .content),
    );
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  void select(int i) {
    emit(
      state.copyWith(
        isSelected: true,
        selectedMessageIndex: i,
      ),
    );
  }

  void addImage(int eventPageIndex) async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    var message;
    if (state.isSelected) {
      var tempDate = eventPages[eventPageIndex]
          .eventMessages[state.selectedMessageIndex]
          .date;
      delete(eventPageIndex);
      message = EventMessage(image, tempDate);
      eventPages[eventPageIndex]
          .eventMessages
          .insert(state.selectedMessageIndex, message);
      emit(
        state.copyWith(
          messages: eventPages[eventPageIndex].eventMessages,
          categoryIcon: null,
        ),
      );
    } else {
      message = EventMessage(
        image,
        Jiffy(DateTime.now()).format('d/M/y h:mm a'),
      );
      eventPages[eventPageIndex].eventMessages.add(message);
    }
    emit(
      state.copyWith(
        messages: eventPages[eventPageIndex].eventMessages,
        categoryIcon: null,
      ),
    );
  }

  void _addEdited(
    int eventPageIndex,
    TextEditingController controller,
  ) {
    var tempDate = eventPages[eventPageIndex]
        .eventMessages[state.selectedMessageIndex]
        .date;
    var message;
    if (state.isCategoryPanelOpened) {
      message = EventMessage(
        controller.text,
        tempDate,
        icon: state.categoryIcon,
      );
    } else {
      message = EventMessage(controller.text, tempDate);
    }
    delete(eventPageIndex);
    eventPages[eventPageIndex]
        .eventMessages
        .insert(state.selectedMessageIndex, message);
    emit(
      state.copyWith(
        messages: eventPages[eventPageIndex].eventMessages,
        isSelected: false,
        categoryIcon: null,
        needsEditing: false,
      ),
    );
  }

  void addMessage(BuildContext context, int eventPageIndex,
      TextEditingController controller) {
    if (state.needsEditing) {
      _addEdited(
        eventPageIndex,
        controller,
      );
    } else {
      var message;
      if (state.isCategoryPanelOpened) {
        message = EventMessage(
            controller.text, Jiffy(DateTime.now()).format('d/M/y h:mm a'),
            icon: state.categoryIcon);
      } else {
        message = EventMessage(
          controller.text,
          Jiffy(DateTime.now()).format('d/M/y h:mm a'),
        );
      }
      eventPages[eventPageIndex].eventMessages.add(message);
      emit(
        state.copyWith(
          messages: eventPages[eventPageIndex].eventMessages,
          categoryIcon: null,
        ),
      );
    }
    controller.clear();
  }

  void moveMessage(
    int chosenPageIndex,
    int eventPageIndex,
    BuildContext context,
  ) {
    var message =
        eventPages[eventPageIndex].eventMessages[state.selectedMessageIndex];
    eventPages[chosenPageIndex].eventMessages.add(message);
    delete(eventPageIndex);
    Navigator.of(context).pop();
  }

  void openCategoryPanel() {
    emit(state.copyWith(
      isCategoryPanelOpened: true,
    ));
  }

  void closeCategoryPanel() {
    emit(state.copyWith(
      isCategoryPanelOpened: false,
      categoryIcon: null,
    ));
  }

  void setCategory(IconData categoryIcon) {
    emit(state.copyWith(
      categoryIcon: categoryIcon,
    ));
  }
}
