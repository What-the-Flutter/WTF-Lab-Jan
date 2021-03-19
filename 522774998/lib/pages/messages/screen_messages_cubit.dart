import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../model/property_message.dart';
import '../../model/property_page.dart';
import '../../repository/messages_repository.dart';
import 'screen_messages.dart';

part 'screen_messages_state.dart';

class ScreenMessagesCubit extends Cubit<ScreenMessagesState> {
  MessagesRepository repository;

  final controller = TextEditingController();

  ScreenMessagesCubit({
    this.repository,
  }) : super(
          ScreenMessageAwait(
            appBar: InputAppBar(
              title: 'Title',
            ),
            counter: 0,
            list: <PropertyMessage>[],
          ),
        );

  void changeCategory(IconData categoryIcon) {
    emit(
      ScreenMessageInput(
        category: categoryIcon,
      ),
    );
  }

  void downloadData(
    PropertyPage page,
    Widget appBar,
  ) async {
    emit(
      ScreenMessageInput(
        page: page,
        appBar: appBar,
        list: await repository.messages(page.id),
        counter: 0,
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
                iconData: Icons.send,
                onAddMessage:
                    state is ScreenMessageInput ? addTextMessage : editMessage,
              ),
            ),
    );
  }

  Future<void> addPhotoMessage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    repository.addMessage(
      ImageMessage(
        idMessagePage: state.page.id,
        data: pickedFile.path,
        isSelected: false,
        time: DateTime.now(),
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

  void addTextMessage() async {
    repository.addMessage(
      TextMessage(
        idMessagePage: state.page.id,
        data: controller.text,
        isSelected: false,
        time: DateTime.now(),
      ),
    );
    controller.text = '';
    emit(
      state.copyWith(
        list: await repository.messages(state.page.id),
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

  void toSelectionAppBar() {
    emit(
      ScreenMessageSelection(
        page: state.page,
        appBar: SelectionAppBar(),
        list: state.list,
        counter: state.counter,
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
          counter: 0,
          iconData: state.iconData,
          onAddMessage: addPhotoMessage),
    );
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
        onEditMessage: editMessage,
      ),
    );
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
        iconData: state.iconData,
        onAddMessage: addPhotoMessage,
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

  void listSelected(int idMessagePage) {
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        repository.editMessage(state.list[i].copyWith(
          idMessagePage: idMessagePage,
          isSelected: false,
        ));
      }
    }
    toInputAppBar();
  }

  int checkDate(DateTime time, int index) {
    var timeOfSending = DateFormat('yyyy-MM-dd').format(time);
    for (var i = 0; i < state.list.length; i++) {
      if (index == state.list[i].idMessagePage) {
        if (DateFormat('yyyy-MM-dd').format(state.list[i].time) ==
            timeOfSending) {
          return state.list[i].id;
        }
      }
    }
    return 0;
  }

  String calculateDate(DateTime dateOfSending) {
    final dateToday = DateTime.now();
    final difference = dateToday.difference(dateOfSending).inDays;
    switch (difference) {
      case 0:
        return 'Today';
        break;
      case 1:
        return 'Yesterday';
        break;
      case 7:
        return 'Week ago';
        break;
      default:
        if (difference > 7) {
          return DateFormat.yMMMMd('en_US').format(dateOfSending);
        } else {
          return '$difference days ago';
        }
    }
  }

  @override
  Future<Function> close() {
    controller.dispose();
    return super.close();
  }
}
