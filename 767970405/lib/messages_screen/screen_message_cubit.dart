import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../data/model/model_message.dart';
import '../data/model/model_page.dart';
import '../data/repository/messages_repository.dart';
import 'screen_message.dart';

part 'screen_message_state.dart';

class ScreenMessageCubit extends Cubit<ScreenMessageState> {
  final MessagesRepository repository;

  final controller = TextEditingController();

  ScreenMessageCubit({
    this.repository,
  }) : super(
          ScreenMessageAwait(
            appBar: InputAppBar(
              title: 'Title',
            ),
            counter: 0,
            isBookmark: false,
            list: <ModelMessage>[],
          ),
        );

  void downloadData(
    ModelPage page,
    Widget appBar,
  ) async {
    emit(
      ScreenMessageInput(
        page: page,
        appBar: appBar,
        list: await repository.messages(page.id),
        counter: 0,
        isBookmark: false,
      ),
    );
    controller.addListener(
      () => controller.text.isEmpty
          ? emit(
              state.copyWith(
                iconData: Icons.photo_camera,
                onAddMessage:
                    state is ScreenMessageInput ? addPhotoMessage : editMessage,
              ),
            )
          : emit(
              state.copyWith(
                iconData: Icons.add,
                onAddMessage:
                    state is ScreenMessageInput ? addTextMessage : editMessage,
              ),
            ),
    );
  }

  void showBookmarkMessage() {
    emit(state.copyWith(isBookmark: !state.isBookmark));
  }

  void addTextMessage() async {
    repository.addMessage(
      TextMessage(
        pageId: state.page.id,
        data: controller.text,
        isFavor: state.isBookmark,
        isSelected: false,
      ),
    );
    controller.text = '';
    emit(
      state.copyWith(
        list: await repository.messages(state.page.id),
      ),
    );
  }

  void toSelectionAppBar() {
    emit(
      ScreenMessageSelection(
        page: state.page,
        appBar: SelectionAppBar(),
        list: state.list,
        counter: state.counter,
        isBookmark: state.isBookmark,
        iconData: state.iconData,
        onAddMessage: null,
      ),
    );
  }

  void toInputAppBar() async {
    emit(
      ScreenMessageInput(
          page: state.page,
          appBar: InputAppBar(
            title: state.page.title,
          ),
          list: await repository.messages(state.page.id),
          isBookmark: state.isBookmark,
          counter: 0,
          iconData: state.iconData,
          onAddMessage: addPhotoMessage),
    );
  }

  Future<void> addPhotoMessage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    repository.addMessage(
      ImageMessage(
        pageId: state.page.id,
        data: pickedFile.path,
        isFavor: state.isBookmark,
        isSelected: false,
      ),
    );
    emit(
      state.copyWith(
        list: await repository.messages(state.page.id),
      ),
    );
  }

  bool isPhotoMessage() {
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected && state.list[i] is ImageMessage) {
        return true;
      }
    }
    return false;
  }

  void selection(int index) async {
    var isSelected = state.list[index].isSelected;
    repository.editMessage(state.list[index].copyWith(isSelected: !isSelected));
    if (isSelected) {
      emit(state.copyWith(
        list: await repository.messages(state.page.id),
        counter: state.counter - 1,
      ));
    } else {
      emit(state.copyWith(
        list: await repository.messages(state.page.id),
        counter: state.counter + 1,
      ));
    }
  }

  void listSelected(int pageId) {
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        repository.editMessage(state.list[i].copyWith(
          pageId: pageId,
          isSelected: false,
        ));
      }
    }
    toInputAppBar();
  }

  void toEditAppBar() {
    String text;
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        text = state.list[i].data;
      }
    }
    controller.text = text;
    emit(
      ScreenMessageEdit(
        page: state.page,
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
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        index = i;
        break;
      }
    }
    repository.editMessage(
        state.list[index].copyWith(data: controller.text, isSelected: false));
    controller.text = '';
    toInputAppBar();
  }

  void copy() {
    var clipBoard = '';
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        clipBoard += state.list[i].data;
        selection(i);
      }
    }
    Clipboard.setData(ClipboardData(text: clipBoard));
  }

  void makeFavor() async {
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        repository.editMessage(
          state.list[i].copyWith(
            isFavor: !state.list[i].isFavor,
            isSelected: false,
          ),
        );
      }
    }
    toInputAppBar();
  }

  void delete() async {
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        repository.removeMessage(state.list[i].id);
      }
    }
    emit(
      state.copyWith(
        counter: 0,
        list: await repository.messages(state.page.id),
      ),
    );
  }

  void remove(int id) {
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        repository.removeMessage(state.list[i].id);
      }
    }
  }

  void backToInputAppBar() async {
    controller.text = '';
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        selection(i);
      }
    }
    emit(
      ScreenMessageInput(
        page: state.page,
        appBar: InputAppBar(
          title: state.page.title,
        ),
        list: await repository.messages(state.page.id),
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
