import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../repository/icons_repository.dart';

part 'creating_new_page_state.dart';

class CreatingNewPageCubit extends Cubit<CreatingNewPageState> {
  final IconsRepository repository;

  CreatingNewPageCubit({
    this.repository,
  }) : super(
    CreatingNewPageStateInitial(
      list: List.from(repository.listIcon),
    ),
  );

  void setIconIndex(int selectionIconIndex) {
    repository.listIcon[selectionIconIndex] =
        repository.listIcon[selectionIconIndex].copyWith(isSelected: true);
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
