import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../repository/pages_repository.dart';
import '../repository/property_page.dart';

part 'dialog_page_state.dart';

class DialogPageCubit extends Cubit<DialogPageState> {
  final PagesRepository repository;

  DialogPageCubit({
    @required this.repository,
    @required int index,
  }) : super(
          DialogPageState(
            title: repository.dialogPages[index].title,
            icon: repository.dialogPages[index].icon,
            isPin: repository.dialogPages[index].isPin,
            time: repository.dialogPages[index].creationTime,
          ),
        );

  void refreshDate(int index) {
    emit(
      state.copyWith(
        title: repository.dialogPages[index].title,
        icon: repository.dialogPages[index].icon,
        isPin: repository.dialogPages[index].isPin,
        time: repository.dialogPages[index].creationTime,
      ),
    );
  }

  void pinPage(int index) {
    repository.dialogPages[index] =
        repository.dialogPages[index].copyWith(isPin: !state.isPin);
    emit(state.copyWith(isPin: !state.isPin));
  }

  void editPage(int index, PropertyPage page) {
    repository.dialogPages[index] = page;
    emit(state.copyWith(icon: page.icon, title: page.title));
  }
}
