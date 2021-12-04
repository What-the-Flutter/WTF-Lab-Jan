import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/event.dart';

part 'create_event_state.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit() : super(CreateEventState());

  late IconData _currentIcon;

  final List<IconData> _icons = <IconData>[
    Icons.collections_bookmark,
    Icons.menu_book_outlined,
    Icons.favorite,
    Icons.ac_unit,
    Icons.wine_bar,
    Icons.thumb_up_alt_outlined,
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

  void loadIcons() {
    emit(
      CreateEventState(
        icons: _icons,
        currentIcon: _icons.first,
      ),
    );
  }

  Event? createEvent(String title) {
    Event updatedPage;
    if (title.isEmpty) return null;
    if (state.editPage != null) {
      updatedPage = Event.from(state.editPage!);
      updatedPage
        ..title = title
        ..icon = Icon(state.currentIcon, color: Colors.white);
    } else {
      updatedPage = Event(
        title: title,
        icon: Icon(state.currentIcon, color: Colors.white),
      );
    }
    return updatedPage;
  }

  void setEditEvent(Event? page) {
    if (page == null) {
      emit(state.copyWith(
        editPage: page,
        currentIcon: state.icons.first,
      ));
    } else {
      final icons = List<IconData>.from(state.icons);
      final currentIndex = icons.indexOf(page.icon.icon!);
      if (currentIndex != 0) {
        _currentIcon = page.icon.icon!;
      }

      emit(state.copyWith(
        icons: icons,
        editPage: page,
        currentIcon: _currentIcon,
      ));
    }
  }

  void currentIcon(IconData icon) {
    emit(state.copyWith(currentIcon: icon));
  }
}
