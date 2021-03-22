import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../repository/icons_repository.dart';

part 'creating_new_page_state.dart';

class CreatingNewPageCubit extends Cubit<CreatingNewPageState> {
  final IconsRepository repository;
  final controller = TextEditingController();

  CreatingNewPageCubit({
    this.repository,
  }) : super(
          CreatingNewPageStateInitial(
            list: List.from(repository.listIcon),
          ),
        );

  void changeButton() {
    if (controller.text.isEmpty) {
      emit(state.copyWith(iconButton: Icons.close));
    } else {
      emit(state.copyWith(iconButton: Icons.done));
    }
  }

  void setting(String title, int selectionIconIndex) {
    controller.addListener(changeButton);
    repository.listIcon[selectionIconIndex] =
        repository.listIcon[selectionIconIndex].copyWith(isSelected: true);
    controller.text = title;
    emit(
      CreatingNewPageStateWork(
        list: List.from(repository.listIcon),
        selectionIconIndex: selectionIconIndex,
      ),
    );
  }

  IconData getIcon(int index) {
    return repository.listIcon[index].iconData;
  }

  void resetIcon() {
    repository.listIcon[state.selectionIconIndex] = repository
        .listIcon[state.selectionIconIndex]
        .copyWith(isSelected: false);
    emit(
      state.copyWith(
        list: List.from(repository.listIcon),
      ),
    );
  }

  void selectionIcon(int index) {
    repository.listIcon[state.selectionIconIndex] = repository
        .listIcon[state.selectionIconIndex]
        .copyWith(isSelected: false);
    repository.listIcon[index] =
        repository.listIcon[index].copyWith(isSelected: true);
    emit(
      state.copyWith(
        list: List.from(repository.listIcon),
        selectionIconIndex: index,
      ),
    );
  }
}
