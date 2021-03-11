import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../repository/icons_repository.dart';
import 'label_cubit.dart';

part 'screen_creating_page_state.dart';

class ScreenCreatingPageCubit extends Cubit<ScreenCreatingPageState> {
  final controller = TextEditingController();
  final IconsRepository repository;
  final List<LabelCubit> list = <LabelCubit>[];

  ScreenCreatingPageCubit({this.repository})
      : super(ScreenCreatingPageState(
          iconButton: Icons.close,
          selectionIcon: repository.listIcon[0].icon,
        ));

  void changeButton() {
    if (controller.text.isEmpty) {
      emit(ScreenCreatingPageState(
          selectionIcon: state.selectionIcon, iconButton: Icons.close));
    } else {
      emit(ScreenCreatingPageState(
          selectionIcon: state.selectionIcon, iconButton: Icons.done));
    }
  }

  void updateList(int index) {
    for (var i = 0; i < repository.listIcon.length; i++) {
      if (i == index) {
        continue;
      }
      if (repository.listIcon[i].isVisible) {
        repository.listIcon[i] =
            repository.listIcon[i].copyWith(isVisible: false);
        list[i].uncheckedLabel();
        break;
      }
    }
    emit(ScreenCreatingPageState(
      iconButton: state.iconButton,
      selectionIcon: repository.listIcon[index].icon,
    ));
  }

  void findIcon(IconData icon) {
    for (var i = 0; i < repository.listIcon.length; i++) {
      if (repository.listIcon[i].icon == icon) {
        repository.listIcon[i] =
            repository.listIcon[i].copyWith(isVisible: true);
        emit(ScreenCreatingPageState(
            iconButton: state.iconButton, selectionIcon: icon));
        break;
      }
    }
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
