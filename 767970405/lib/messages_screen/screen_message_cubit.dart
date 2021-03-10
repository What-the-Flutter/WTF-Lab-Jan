import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../data/model/model_message.dart';
import '../data/repository/messages_repository.dart';
import 'screen_message.dart';

part 'screen_message_state.dart';

class ScreenMessageCubit extends Cubit<ScreenMessageState> {
  final MessagesRepository repository;
  final String title;

  final controller = TextEditingController();

  ScreenMessageCubit({
    this.repository,
    this.title,
    Widget appBar,
  }) : super(ScreenMessageInput(
          appBar: appBar,
          list: List<ModelMessage>.from(repository.messages),
          isBookmark: false,
          counter: 0,
        )) {
    controller.addListener(() {
      if (controller.text.isEmpty) {
        emit(state.copyWith(
          iconData: Icons.photo_camera,
          onAddMessage:
              state is ScreenMessageInput ? addPhotoMessage : editMessage,
        ));
      } else {
        emit(state.copyWith(
          iconData: Icons.add,
          onAddMessage:
              state is ScreenMessageInput ? addTextMessage : editMessage,
        ));
      }
    });
  }

  void showBookmarkMessage() {
    emit(state.copyWith(isBookmark: !state.isBookmark));
  }

  void addTextMessage() {
    repository.messages.add(TextMessage(
      data: controller.text,
      isFavor: false,
      isSelected: false,
    ));
    controller.text = '';
    emit(state.copyWith(list: List<ModelMessage>.from(repository.messages)));
  }

  void toSelectionAppBar() {
    emit(
      ScreenMessageSelection(
        appBar: SelectionAppBar(),
        list: state.list,
        counter: state.counter,
        isBookmark: state.isBookmark,
        iconData: state.iconData,
        onAddMessage: null,
      ),
    );
  }

  void toInputAppBar(String title) {
    emit(
      ScreenMessageInput(
          appBar: InputAppBar(
            title: title,
          ),
          list: List<ModelMessage>.from(repository.messages),
          isBookmark: state.isBookmark,
          counter: 0,
          iconData: state.iconData,
          onAddMessage: addPhotoMessage),
    );
  }

  Future<void> addPhotoMessage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    repository.messages.add(ImageMessage(
      data: pickedFile.path,
      isFavor: false,
      isSelected: false,
    ));
    emit(state.copyWith(list: List<ModelMessage>.from(repository.messages)));
  }

  void selection(int index) {
    var isSelected = repository.messages[index].isSelected;
    repository.messages[index] =
        repository.messages[index].copyWith(isSelected: !isSelected);
    if (isSelected) {
      emit(state.copyWith(
        list: List<ModelMessage>.from(repository.messages),
        counter: state.counter - 1,
      ));
    } else {
      emit(state.copyWith(
        list: List<ModelMessage>.from(repository.messages),
        counter: state.counter + 1,
      ));
    }
  }

  void toEditAppBar() {
    String text;
    for (var i = 0; i < repository.messages.length; i++) {
      if (state.list[i].isSelected) {
        text = state.list[i].data;
      }
    }
    controller.text = text;
    emit(
      ScreenMessageEdit(
        appBar: EditAppBar(
          title: 'Edit mode',
        ),
        list: state.list,
        counter: state.counter,
        iconData: state.iconData,
        isBookmark: state.isBookmark,
        onEditMessage: editMessage,
      ),
    );
  }

  void editMessage() {
    int index;
    for (var i = 0; i < repository.messages.length; i++) {
      if (state.list[i].isSelected) {
        index = i;
        break;
      }
    }
    repository.messages[index] = repository.messages[index]
        .copyWith(data: controller.text, isSelected: false);
    controller.text = '';
    toInputAppBar('title');
  }

  void copy() {
    var clipBoard = '';
    for (var i = 0; i < repository.messages.length; i++) {
      if (state.list[i].isSelected) {
        clipBoard += state.list[i].data;
        selection(i);
      }
    }
    Clipboard.setData(ClipboardData(text: clipBoard));
  }

  void makeFavor() {
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        repository.messages[i] = repository.messages[i]
            .copyWith(isFavor: !repository.messages[i].isFavor);
        selection(i);
      }
    }
  }

  void delete() {
    var index = 0;
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        repository.messages.removeAt(index);
        index--;
      }
      index++;
    }
    emit(state.copyWith(
        counter: 0, list: List<ModelMessage>.from(repository.messages)));
  }

  void backToInputAppBar() {
    controller.text = '';
    for (var i = 0; i < repository.messages.length; i++) {
      if (state.list[i].isSelected) {
        selection(i);
      }
    }
    emit(
      ScreenMessageInput(
        appBar: InputAppBar(
          title: title,
        ),
        list: List<ModelMessage>.from(repository.messages),
        counter: 0,
        isBookmark: state.isBookmark,
        iconData: state.iconData,
        onAddMessage: addPhotoMessage,
      ),
    );
  }

  @override
  Future<Function> close() {
    controller.dispose();
    super.close();
  }
}
