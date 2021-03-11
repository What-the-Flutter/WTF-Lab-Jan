import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit({String message, bool isFavor, IconData icon})
      : super(
          MessageState(isSelected: false, message: message, icon: icon),
        );

  void selected() => emit(
        state.copyWith(
          isSelected: !state.isSelected,
          onTap: state.onTap,
        ),
      );

  void edit(String message) => emit(state.copyWith(message: message));

  void update(bool isNull) {
    if (!isNull) {
      emit(state.copyWith(onTap: selected));
    } else {
      emit(state.copyWith(onTap: null));
    }
  }
}
