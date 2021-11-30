import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../resources/icon_list.dart';

part 'state.dart';

class IconGridViewCubit extends Cubit<IconGridViewState> {
  IconGridViewCubit() : super(IconGridViewState(IconList.iconList, 0));

  void changeSelectedIcon(int index) =>
      emit(state.copyWith(selectedIcon: index));
}
