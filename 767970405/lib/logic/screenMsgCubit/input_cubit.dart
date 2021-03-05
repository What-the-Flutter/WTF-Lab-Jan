import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'input_state.dart';

class InputCubit extends Cubit<InputState> {
  final controller = TextEditingController();

  InputCubit({Function onTap})
      : super(
          InputState(
            isEditable: true,
            action: Action(
              icon: Icons.photo_camera,
              onTap: onTap,
            ),
          ),
        ) {
    controller.addListener(changeAction);
  }

  void changeAction() {
    if (controller.text.isEmpty) {
      emit(
        InputState(
          isEditable: true,
          action: Action(
            icon: Icons.photo_camera,
            onTap: () {},
          ),
        ),
      );
    } else {
      emit(
        InputState(
          isEditable: true,
          action: Action(icon: Icons.arrow_forward_ios_rounded, onTap: () {}),
        ),
      );
    }
  }

  void editable() {
    emit(
      InputState(
        isEditable: !state.isEditable,
        action: state.action,
      ),
    );
  }
}

class Action implements Equatable {
  final IconData icon;
  final Function onTap;

  Action({this.icon, this.onTap});

  @override
  List<Object> get props => [icon];

  @override
  bool get stringify => true;
}
