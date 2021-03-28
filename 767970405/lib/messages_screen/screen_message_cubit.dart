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
    DateTime time,
  }) : super(
          ScreenMessageState(
            fromDate: time,
            fromTime: TimeOfDay.fromDateTime(time),
            isReset: false,
            mode: Mode.await,
            counter: 0,
            isBookmark: false,
            list: <ModelMessage>[],
            enabledController: true,
            floatingBar: FloatingBar.nothing,
            indexCategory: -1,
            iconDataPhoto: Icons.photo_camera,
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
        onAddCategory: showEventList,
      ),
    );
    controller.addListener(
      () => controller.text.isEmpty
          ? emit(
              state.copyWith(
                iconDataPhoto: Icons.photo_camera,
                onAddMessage:
                    state.mode == Mode.input ? showPhotoOption : editMessage,
              ),
            )
          : emit(
              state.copyWith(
                iconDataPhoto: Icons.add,
                onAddMessage:
                    state.mode == Mode.input ? addTextMessage : editMessage,
              ),
            ),
    );
  }

  void showBookmarkMessage() {
    emit(state.copyWith(isBookmark: !state.isBookmark));
  }

  void addTextMessage() async {
    repository.addMessage(
      ModelMessage(
        pageId: state.page.id,
        text: controller.text,
        isFavor: state.isBookmark,
        isSelected: false,
        indexCategory: state.indexCategory,
        photo: null,
        pubTime: state.isReset
            ? state.fromDate.applied(state.fromTime)
            : DateTime.now(),
      ),
    );
    controller.text = '';
    emit(
      state.copyWith(
        list: await repository.messages(state.page.id),
        indexCategory: -1,
        floatingBar: FloatingBar.nothing,
        iconDataPhoto: Icons.photo_camera,
        onAddMessage: showPhotoOption,
      ),
    );
  }

  void toSelectionAppBar() {
    emit(state.copyWith(
      mode: Mode.selection,
      onAddMessage: null,
    ));
  }

  void toInputAppBar() async {
    emit(state.copyWith(
      mode: Mode.input,
      list: await repository.messages(state.page.id),
      counter: 0,
      indexCategory: -1,
      onAddCategory: showEventList,
      iconDataPhoto: Icons.photo_camera,
      onAddMessage: showPhotoOption,
    ));
  }

  List<List<ModelMessage>> get groupMsgByDate {
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
    if (state.list.isNotEmpty) {
      temp.add(state.list[state.list.length - 1]);
      list.add(List.from(temp));
    }
    return list;
  }

  Future<void> addPhotoMessage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    repository.addMessage(
      ModelMessage(
        pageId: state.page.id,
        photo: pickedFile.path,
        isFavor: state.isBookmark,
        isSelected: false,
        text: null,
        indexCategory: null,
        pubTime: state.isReset
            ? state.fromDate.applied(state.fromTime)
            : DateTime.now(),
      ),
    );
    emit(
      state.copyWith(
        list: await repository.messages(state.page.id),
      ),
    );
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
    var index = 0;
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        index = i;
        break;
      }
    }
    controller.text = state.list[index].text;
    emit(
      state.copyWith(
        mode: Mode.edit,
        onAddMessage: editMessage,
        indexCategory: state.list[index].indexCategory,
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
    repository.editMessage(state.list[index].copyWith(
      text: controller.text,
      isSelected: false,
      indexCategory: state.indexCategory,
    ));
    toInputAppBar();
    controller.text = '';
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

  void showEventList() {
    emit(state.copyWith(
      floatingBar: FloatingBar.events,
      onAddCategory: closeFloatingBar,
    ));
  }

  void closeFloatingBar() {
    emit(state.copyWith(
      floatingBar: FloatingBar.nothing,
      onAddCategory: showEventList,
      onAddMessage: showPhotoOption,
    ));
  }

  void cancelSelected() {
    emit(state.copyWith(
      floatingBar: FloatingBar.nothing,
      onAddCategory: showEventList,
      indexCategory: -1,
      onAddMessage: state.mode == Mode.input ? showPhotoOption : null,
      iconDataPhoto: state.mode == Mode.input ? Icons.photo_camera : null,
    ));
  }

  void showPhotoOption() {
    emit(state.copyWith(
      floatingBar: FloatingBar.photosOption,
      onAddMessage: closeFloatingBar,
    ));
  }

  void selectedCategory(int index) {
    emit(state.copyWith(
      floatingBar: FloatingBar.nothing,
      onAddCategory: showEventList,
      indexCategory: index,
      iconDataPhoto: Icons.add,
      onAddMessage: state.mode == Mode.input ? addTextMessage : editMessage,
    ));
  }

  void updateDateAndTime({
    DateTime date,
    TimeOfDay time,
  }) {
    if (date != state.fromDate || time != state.fromTime) {
      emit(state.copyWith(
        fromDate: date,
        fromTime: time,
        isReset: true,
      ));
    }
  }

  void reset() {
    final date = DateTime.now();
    emit(state.copyWith(
      fromDate: date,
      fromTime: TimeOfDay.fromDateTime(date),
      isReset: false,
    ));
  }

  @override
  Future<Function> close() {
    controller.dispose();
    super.close();
  }
}
