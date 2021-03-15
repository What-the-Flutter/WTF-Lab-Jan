import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../repository/icons_repository.dart';

part 'creating_new_page_state.dart';

class CreatingNewPageCubit extends Cubit<CreatingNewPageState> {
  final controller = TextEditingController();
  final List<ListItemIcon> repository;

  CreatingNewPageCubit({this.repository})
      : super(
          CreatingNewPageState(
            iconButton: Icons.close,
            selectionIcon: listIcon[0].iconData,
          ),
        );

  void changeButton() {
    if (controller.text.isEmpty) {
      emit(
        CreatingNewPageState(
            selectionIcon: state.selectionIcon, iconButton: Icons.close),
      );
    } else {
      emit(
        CreatingNewPageState(
            selectionIcon: state.selectionIcon, iconButton: Icons.done),
      );
    }
  }

  void updateList(int index) {
    for (var i = 0; i < listIcon.length; i++) {
      if (i == index) {
        continue;
      }
      if (listIcon[i].isSelected) {
        listIcon[i].isSelected = false;
        break;
      }
    }
    emit(
      CreatingNewPageState(
        iconButton: state.iconButton,
        selectionIcon: listIcon[index].iconData,
      ),
    );
  }

  void findIcon(IconData icon) {
    for (var i = 0; i < listIcon.length; i++) {
      if (listIcon[i].iconData == icon) {
        listIcon[i].isSelected = true;
      } else {
        listIcon[i].isSelected = false;
      }
    }
    emit(
      CreatingNewPageState(iconButton: state.iconButton, selectionIcon: icon),
    );
  }

  @override
  Future<void> close() async {
    controller.dispose();
    super.close();
  }

  void settingsController(String title) {
    controller.addListener(changeButton);
    controller.text = title;
  }
}
