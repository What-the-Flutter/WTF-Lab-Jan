import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../data/model/label_model.dart';
import '../data/repository/icons_repository.dart';

part 'screen_creating_page_state.dart';

class ScreenCreatingPageCubit extends Cubit<ScreenCreatingPageState> {
  final controller = TextEditingController();
  final IconsRepository repository;

  ScreenCreatingPageCubit({
    this.repository,
  }) : super(
          ScreenCreatingPageInitial(
            list: List.from(repository.listIcon),
          ),
        );

  void setting(String title, int selectionIconIndex) {
    controller.addListener(changeButton);
    repository.listIcon[selectionIconIndex] =
        repository.listIcon[selectionIconIndex].copyWith(isSelected: true);
    controller.text = title;
    emit(
      ScreenCreatingPageWork(
        list: List.from(repository.listIcon),
        selectionIconIndex: selectionIconIndex,
      ),
    );
  }

  IconData getIcon(int index) {
    return repository.listIcon[index].icon;
  }

  void changeButton() {
    if (controller.text.isEmpty) {
      emit(state.copyWith(iconButton: Icons.close));
    } else {
      emit(state.copyWith(iconButton: Icons.done));
    }
  }

  void resetIcon() {
    repository.listIcon[state.selectionIconIndex] = repository
        .listIcon[state.selectionIconIndex]
        .copyWith(isSelected: false);
    emit(state.copyWith(list: List.from(repository.listIcon)));
  }

  void selectionIcon(int index) {
    repository.listIcon[state.selectionIconIndex] = repository
        .listIcon[state.selectionIconIndex]
        .copyWith(isSelected: false);
    repository.listIcon[index] =
        repository.listIcon[index].copyWith(isSelected: true);
    emit(state.copyWith(
      list: List.from(repository.listIcon),
      selectionIconIndex: index,
    ));
  }

  @override
  Future<void> close() async {
    controller.dispose();
    super.close();
  }
}
