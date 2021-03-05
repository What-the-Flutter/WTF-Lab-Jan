import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit({String message, bool isFavor})
      : super(
    MessageState(
      isFavor: isFavor,
      isSelected: false,
      message: message,
    ),
  );

  void makeFavor(bool isFavor) => emit(
    state.copyWith(
      isFavor: isFavor,
      onTap: state.onTap,
    ),
  );

  void selected() => emit(
    state.copyWith(
      isSelected: !state.isSelected,
      onTap: state.onTap,
    ),
  );

  void edit(String message, bool isFavor) =>
      emit(state.copyWith(message: message, isFavor: isFavor));

  void update(bool isNull) {
    if (!isNull) {
      emit(state.copyWith(onTap: selected));
    } else {
      emit(state.copyWith(onTap: null));
    }
  }
}
