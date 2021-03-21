import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../data/model/model_message.dart';
import '../data/model/model_page.dart';
import '../data/repository/messages_repository.dart';

part 'screen_message_state.dart';

class ScreenMessageCubit extends Cubit<ScreenMessageState> {
  final MessagesRepository repository;

  final controller = TextEditingController();

  ScreenMessageCubit({
    this.repository,
  }) : super(
          ScreenMessageState(
            mode: Mode.await,
            counter: 0,
            isBookmark: false,
            list: <ModelMessage>[],
            enabledController: true,
            iconData: Icons.photo_camera,
          ),
        );

  void downloadData(
    ModelPage page,
  ) async {
    emit(
      state.copyWith(
        page: page,
        mode: Mode.input,
        list: await repository.messages(page.id),
      ),
    );
    controller.addListener(
      () => controller.text.isEmpty
          ? emit(
              state.copyWith(
                iconData: Icons.photo_camera,
                onAddMessage:
                    state.mode == Mode.input ? addPhotoMessage : editMessage,
              ),
            )
          : emit(
              state.copyWith(
                iconData: Icons.add,
                onAddMessage:
                    state.mode == Mode.input ? addTextMessage : editMessage,
              ),
            ),
    );
  }

  void showBookmarkMessage() {
    emit(state.copyWith(isBookmark: !state.isBookmark));
  }

  void addTextMessage(DateTime pubTime) async {
    repository.addMessage(
      ModelMessage(
        pageId: state.page.id,
        text: controller.text,
        isFavor: state.isBookmark,
        isSelected: false,
        indexCategory: null,
        photo: null,
        pubTime: pubTime,
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
    emit(state.copyWith(mode: Mode.selection, onAddMessage: null));
  }

  void toInputAppBar() async {
    emit(state.copyWith(
      mode: Mode.input,
      list: await repository.messages(state.page.id),
      counter: 0,
    ));
  }

  List<List<ModelMessage>> get filterMsg {
    var list = <List<ModelMessage>>[];
    var temp = <ModelMessage>[];
    if (state.list.length == 1) {
      temp.add(state.list[0]);
      list.add(List.from(temp));
      return list;
    }
    for (var i = 0; i < state.list.length - 1; i++) {
      temp.add(state.list[i]);
      if (!state.list[i].pubTime.isSameDate(state.list[i + 1].pubTime)) {
        list.add(List.from(temp));
        temp = <ModelMessage>[];
      }
    }
    temp.add(state.list[state.list.length - 1]);
    list.add(List.from(temp));
    return list;
  }

  Future<void> addPhotoMessage(DateTime pubTime) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    repository.addMessage(
      ModelMessage(
        pageId: state.page.id,
        photo: pickedFile.path,
        isFavor: state.isBookmark,
        isSelected: false,
        text: null,
        indexCategory: null,
        pubTime: pubTime,
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
      //if (state.list[i].isSelected && state.list[i] is ImageMessage) {
      //return true;
      //}
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
        text = state.list[i].text;
      }
    }
    controller.text = text;
    emit(
      state.copyWith(
        mode: Mode.edit,
        onAddMessage: editMessage,
      ),
    );
  }

  void editMessage(DateTime date) {
    int index;
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        index = i;
        break;
      }
    }
    repository.editMessage(
        state.list[index].copyWith(text: controller.text, isSelected: false));
    controller.text = '';
    toInputAppBar();
  }

  void copy() {
    var clipBoard = '';
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        clipBoard += state.list[i].text;
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
    toInputAppBar();
  }

  @override
  Future<Function> close() {
    controller.dispose();
    super.close();
  }
}
