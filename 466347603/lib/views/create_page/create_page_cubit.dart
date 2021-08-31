import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../modules/page_info.dart';

part 'create_page_state.dart';

class CreatePageCubit extends Cubit<CreatePageState> {
  final List<IconData> _icons = <IconData>[
    Icons.favorite,
    Icons.ac_unit,
    Icons.wine_bar,
    Icons.coffee,
    Icons.local_pizza,
    Icons.money,
    Icons.car_rental,
    Icons.food_bank,
    Icons.navigation,
    Icons.laptop,
    Icons.umbrella,
    Icons.access_alarm,
    Icons.accessible,
    Icons.account_balance,
    Icons.account_circle,
    Icons.adb,
    Icons.add_alarm,
    Icons.add_alert,
    Icons.airplanemode_active,
    Icons.attach_money,
    Icons.audiotrack,
    Icons.av_timer,
    Icons.backup,
    Icons.beach_access,
    Icons.block,
    Icons.brightness_1,
    Icons.bug_report,
    Icons.bubble_chart,
    Icons.call_merge,
    Icons.camera,
    Icons.change_history,
  ];

  CreatePageCubit() : super(CreatePageState());

  void loadIcons() {
    emit(
      CreatePageState(
        icons: _icons,
        selectedIcon: _icons[0],
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
      );
    }
    emit(state.copyWith(editPage: updatedPage));
  }

  void setEditPage(PageInfo? page) {
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
