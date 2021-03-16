import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../../../enums/enums.dart';

part 'app_bar_state.dart';

class AppBarCubit extends Cubit<AppBarState> {
  final String title;

  AppBarCubit({this.title, Function onBack, Function onSearch})
      : super(AppBarInput(title: title, onBack: onBack, onSearch: onSearch));

  void changeToInput({String title, Function onBack, Function onSearch}) {
    emit(AppBarInput(title: title, onBack: onBack, onSearch: onSearch));
  }

  void changeToEdition(
      {String title,
      Function onClose,
      Function onCopy,
      Function onDelete,
      Function onEdit,
      Function onShare}) {
    emit(
      AppBarEdit(
        title: title,
        onCopy: onCopy,
        onDelete: onDelete,
        onEdit: onEdit,
        onClose: onClose,
        onShare: onShare,
      ),
    );
  }

  void changeToSelection(
      {String title,
      Function onClose,
      Function onCopy,
      Function onDelete,
      Function onEdit}) {
    emit(
      AppBarSelected(
        title: title,
        onCopy: onCopy,
        onDelete: onDelete,
        onClose: onClose,
        onEdit: onEdit,
      ),
    );
  }
}
