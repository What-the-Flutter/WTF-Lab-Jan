import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../resources/icon_list.dart';

part 'state.dart';

class AddPageScreenCubit extends Cubit<AddPageScreenState> {
  AddPageScreenCubit() : super(AddPageScreenState(IconList.iconList[0]));

  void changeSelectedIcon(IconData icon) {
    emit(state.copyWith(selectedIcon: icon));
  }
}
