import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../modules/page_info.dart';
import '../../utils/data.dart';

part 'create_page_state.dart';

class CreatePageCubit extends Cubit<CreatePageState> {
  CreatePageCubit() : super(CreatePageState());

  void loadIcons() {
    emit(
      CreatePageState(
        icons: defaultIcons,
        selectedIcon: defaultIcons[0],
      ),
    );
  }

  void createPage(String title) {
    PageInfo updatedPage;
    if (title.isEmpty) {
      return null;
    }
    if (state.editPage != null) {
      updatedPage = PageInfo.from(state.editPage!);
      updatedPage
        ..title = title
        ..icon = Icon(state.selectedIcon, color: Colors.white);
    } else {
      updatedPage = PageInfo(
        title: title,
        icon: Icon(state.selectedIcon, color: Colors.white),
        iconIndex: state.icons.indexOf(state.selectedIcon!),
      );
    }
    emit(state.copyWith(editPage: updatedPage));
  }

  void initEditPage(PageInfo? page) {
    if (page == null) {
      emit(state.copyWith(
        editPage: page,
        selectedIcon: state.icons[0],
      ));
    } else {
      final icons = List<IconData>.from(state.icons);
      final index = icons.indexOf(page.icon.icon!);
      if (index != -1) {
        icons.insert(0, icons.removeAt(index));
      } else {
        icons.insert(0, page.icon.icon!);
      }
      emit(state.copyWith(
        icons: icons,
        editPage: page,
        selectedIcon: icons[0],
      ));
    }
  }

  void selectIcon(IconData icon) {
    emit(state.copyWith(selectedIcon: icon));
  }
}
