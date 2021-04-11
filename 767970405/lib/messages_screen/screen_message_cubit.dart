import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../data/model/model_message.dart';
import '../data/model/model_page.dart';
import '../data/model/model_tag.dart';
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
      curTag: '',
      listTag: ModeListTag.nothing,
    ),
  ) {
    controller.addListener(
      () => controller.text.isEmpty
          ? emit(
              state.copyWith(
                iconDataPhoto: Icons.photo_camera,
                onAddMessage:
                    state.mode == Mode.input ? showPhotoOption : ediTextMessage,
              ),
            )
          : emit(
              state.copyWith(
                iconDataPhoto: Icons.add,
                onAddMessage:
                    state.mode == Mode.input ? addMessage : ediTextMessage,
              ),
            ),
    );
    controller.addListener(showListTags);
    controller.addListener(closeListTags);
    controller.addListener(updateCurTag);
    controller.addListener(updateListTag);
  }

  void downloadData(
    ModelPage page,
  ) async {
    emit(
      state.copyWith(
        page: page,
        mode: Mode.input,
        list: await repository.messages(page.id),
        tags: await repository.tags(),
        onAddCategory: showCategoryList,
      ),
    );
  }

  void showListTags() {
    if (controller.text.endsWith('#') && state.floatingBar != FloatingBar.tag) {
      emit(
        state.copyWith(
          floatingBar: FloatingBar.tag,
          listTag: ModeListTag.listTags,
          curTag: '#',
        ),
      );
    }
  }

  void updateListTag() async {
    if (state.floatingBar == FloatingBar.tag) {
      var tags = (await repository.tags())
          .where((element) => element.name.contains(state.curTag))
          .toList();
      if (tags.isEmpty) {
        emit(state.copyWith(listTag: ModeListTag.newTag, tags: tags));
      } else {
        emit(state.copyWith(tags: tags, listTag: ModeListTag.listTags));
      }
    }
  }

  void updateCurTag() {
    if (state.floatingBar == FloatingBar.tag) {
      var text = controller.text;
      var i = text.lastIndexOf('#');
      var iSpace = text.lastIndexOf(' ', i);
      var lastIndex = iSpace > i ? iSpace : text.length;
      emit(state.copyWith(curTag: text.substring(i, lastIndex)));
    }
  }

  void closeListTags() {
    if (!controller.text.contains('#') ||
        (state.curTag.isNotEmpty && controller.text.endsWith(' '))) {
      emit(
        state.copyWith(
          floatingBar: state.attachedPhotoPath.isEmpty ? FloatingBar.nothing : FloatingBar.attach,
          listTag: ModeListTag.nothing,
        ),
      );
    }
  }

  void showBookmarkMessage() {
    emit(state.copyWith(isBookmark: !state.isBookmark));
  }

  void addMessage() async {
    final listTags = controller.text
        .split(' ')
        .where((element) => element.startsWith('#'))
        .toList();
    if (listTags.isNotEmpty) {
      final tags = await repository.tags();
      for (var i = 0; i < listTags.length; i++) {
        var tag = ModelTag(name: listTags[i]);
        if (!tags.contains(tag)) {
          repository.addTag(tag);
        }
      }
    }
    repository.addMessage(
      ModelMessage(
        pageId: state.page.id,
        text: controller.text,
        isFavor: state.isBookmark,
        isSelected: false,
        indexCategory: state.indexCategory,
        photo: state.attachedPhotoPath,
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
        attachedPhotoPath: '',
        iconDataPhoto: Icons.photo_camera,
        onAddMessage: showPhotoOption,
        curTag: '',
        tags: await repository.tags(),
        listTag: ModeListTag.nothing,
      ),
    );
  }

  void toSelectionAppBar(int index) async {
    await selection(index);
    emit(
      state.copyWith(
        mode: Mode.selection,
        enabledController: false,
      ),
    );
  }

  void toInputAppBar() async {
    emit(
      state.copyWith(
        mode: Mode.input,
        enabledController: true,
        list: await repository.messages(state.page.id),
        counter: 0,
        indexCategory: -1,
        onAddCategory: showCategoryList,
        iconDataPhoto: Icons.photo_camera,
        onAddMessage: showPhotoOption,
        floatingBar: FloatingBar.nothing,
        attachedPhotoPath: '',
      ),
    );
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

  Future<void> attachedPhoto(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    emit(
      state.copyWith(
        attachedPhotoPath: pickedFile.path,
        floatingBar: FloatingBar.attach,
      ),
    );
  }

  void selection(int index) async {
    var isSelected = state.list[index].isSelected;
    repository.editMessage(state.list[index].copyWith(isSelected: !isSelected));
    if (isSelected) {
      emit(
        state.copyWith(
          list: await repository.messages(state.page.id),
          counter: state.counter - 1,
        ),
      );
    } else {
      emit(
        state.copyWith(
          list: await repository.messages(state.page.id),
          counter: state.counter + 1,
        ),
      );
    }
  }

  void listSelected(int pageId) {
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        repository.editMessage(
          state.list[i].copyWith(
            pageId: pageId,
            isSelected: false,
          ),
        );
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
        enabledController: true,
        mode: Mode.edit,
        onAddMessage: ediTextMessage,
        indexCategory: state.list[index].indexCategory,
        attachedPhotoPath: state.list[index].photo,
      ),
    );
  }

  void ediTextMessage() {
    int index;
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        index = i;
        break;
      }
    }
    repository.editMessage(
      state.list[index].copyWith(
        text: controller.text,
        isSelected: false,
        indexCategory: state.indexCategory,
      ),
    );
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

  void delete(int index) async {
    repository.removeMessage(state.list[index].id);
    emit(
      state.copyWith(
        list: await repository.messages(state.page.id),
      ),
    );
  }

  void deleteSelected() async {
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

  void showCategoryList() {
    emit(
      state.copyWith(
        floatingBar: FloatingBar.category,
        onAddCategory: closeFloatingBar,
        onAddMessage: controller.text.isEmpty ? showPhotoOption : addMessage
      ),
    );
  }

  void closeFloatingBar() {
    emit(
      state.copyWith(
        floatingBar: state.attachedPhotoPath.isEmpty ? FloatingBar.nothing : FloatingBar.attach,
        onAddCategory: showCategoryList,
        onAddMessage: controller.text.isEmpty ? showPhotoOption : addMessage,
      ),
    );
  }

  void cancelSelected() {
    emit(
      state.copyWith(
        floatingBar: state.attachedPhotoPath.isEmpty ? FloatingBar.nothing : FloatingBar.attach,
        onAddCategory: showCategoryList,
        indexCategory: -1,
      ),
    );
  }

  void showPhotoOption() {
    emit(
      state.copyWith(
        floatingBar: FloatingBar.photosOption,
        onAddMessage: closeFloatingBar,
        onAddCategory: showCategoryList,
      ),
    );
  }

  void selectedCategory(int index) {
    emit(
      state.copyWith(
        floatingBar: state.attachedPhotoPath.isEmpty ? FloatingBar.nothing : FloatingBar.attach,
        onAddCategory: showCategoryList,
        indexCategory: index,
        iconDataPhoto: Icons.add,
        onAddMessage:
            state.mode == Mode.input ? addMessage : ediTextMessage,
      ),
    );
  }

  void updateDateAndTime({
    DateTime date,
    TimeOfDay time,
  }) {
    if (date != state.fromDate || time != state.fromTime) {
      emit(
        state.copyWith(
          fromDate: date,
          fromTime: time,
          isReset: true,
        ),
      );
    }
  }

  void reset() {
    final date = DateTime.now();
    emit(
      state.copyWith(
        fromDate: date,
        fromTime: TimeOfDay.fromDateTime(date),
        isReset: false,
      ),
    );
  }

  @override
  Future<Function> close() {
    controller.dispose();
    return super.close();
  }
}
