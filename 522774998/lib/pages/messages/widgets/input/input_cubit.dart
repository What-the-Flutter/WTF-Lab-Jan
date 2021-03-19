import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../enums/enums.dart';

part 'input_state.dart';

class InputCubit extends Cubit<InputState> {
  final controller = TextEditingController();

  InputCubit({Function onTap})
      : super(
          InputState(
            action: Action(
              icon: Icons.photo_camera,
              onTap: onTap,
            ),
            mode: Operation.input,
          ),
        ) {
    controller.addListener(changeAction);
  }

  void changeAction() {
    if (controller.text.isEmpty) {
      emit(
        InputState(
          action: Action(
            icon: Icons.photo_camera,
            onTap: () {},
          ),
        ),
      );
    } else {
      emit(
        InputState(
          action: Action(
            icon: Icons.send,
            onTap: () {},
          ),
        ),
      );
    }
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
