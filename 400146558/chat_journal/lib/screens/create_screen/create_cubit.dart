import 'package:chat_journal/models/chaticon_model.dart';
import 'package:chat_journal/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_state.dart';

class CreatePageCubit extends Cubit<CreatePageState> {
  final List<ChatIcon> _iconsList = [
    ChatIcon(
      isSelected: false,
      icon: Icons.sports_basketball,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.child_care,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.monetization_on_outlined,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.airplanemode_on_sharp,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.card_travel,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.directions_car,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.home_outlined,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.star,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.music_note,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.vpn_key,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.brush_outlined,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.title,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.favorite,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.book_rounded,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.nature_people,
    ),
  ];

  CreatePageCubit() : super(CreatePageState());

  void init() => emit(state.copyWith(iconsList: _iconsList));

  void myInit(Chat? editingChat) {
    unselectIcons();
    if (editingChat != null) {
      int _icoIndex = state.iconsList.indexOf(state.iconsList
          .firstWhere((element) => element.icon == editingChat.icon));
      state.iconsList[_icoIndex].isSelected = true;
    } else {
      state.iconsList[0].isSelected = true;
    }
    _updateIconsList();
  }

  void _updateIconsList() {
    emit(state.copyWith(iconsList: state.iconsList));
  }

  void unselectIcons() {
    for (var element in state.iconsList) {
      element.isSelected = false;
    }
  }

  void check(int index) {
    for (var element in state.iconsList) {
      element.isSelected = false;
    }
    state.iconsList[index].isSelected = true;
    _updateIconsList();
  }
}
