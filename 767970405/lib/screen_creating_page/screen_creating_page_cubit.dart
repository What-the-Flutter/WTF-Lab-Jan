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
    String title,
    int selectionIconIndex,
    IconData iconButton,
  }) : super(
          ScreenCreatingPageState(
            list: repository.listIcon,
            title: title,
            selectionIconIndex: selectionIconIndex,
            iconButton: iconButton,
          ),
        ) {
    controller.addListener(changeButton);
    repository.listIcon[state.selectionIconIndex] =
        repository.listIcon[selectionIconIndex].copyWith(isVisible: true);
    controller.text = title;
  }

  void changeButton() {
    if (controller.text.isEmpty) {
      emit(state.copyWith(iconButton: Icons.close));
    } else {
      emit(state.copyWith(iconButton: Icons.done));
    }
  }

  void selectionIcon(int index) {
    repository.listIcon[state.selectionIconIndex] = repository
        .listIcon[state.selectionIconIndex]
        .copyWith(isVisible: false);
    repository.listIcon[index] =
        repository.listIcon[index].copyWith(isVisible: true);
    emit(state.copyWith(
      list: repository.listIcon,
      selectionIconIndex: index,
    ));
  }

  @override
  Future<void> close() async {
    controller.dispose();
    super.close();
  }
}
