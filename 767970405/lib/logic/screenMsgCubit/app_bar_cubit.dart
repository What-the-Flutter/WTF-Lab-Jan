import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../constants/enums.dart';

part 'app_bar_state.dart';

class AppBarCubit extends Cubit<AppBarState> {
  final String title;

  AppBarCubit({
    this.title,
    Function onBack,
    Function onSearch,
    Function onChange,
  }) : super(AppBarInput(
            title: title,
            onBack: onBack,
            onSearch: onSearch,
            onChange: onChange));

  void changeToInput(
      {String title,
      Function onBack,
      Function onSearchMsg,
      Function onChangeList}) {
    emit(AppBarInput(
        title: title,
        onBack: onBack,
        onSearch: onSearchMsg,
        onChange: onChangeList));
  }

  void changeToSelection({
    String title,
    Function onClose,
    Function onCopy,
    Function onDelete,
    Function onFavor,
  }) {
    emit(AppBarSelected(
      title: title,
      onCopy: onCopy,
      onDelete: onDelete,
      onFavor: onFavor,
      onClose: onClose,
    ));
  }
}
