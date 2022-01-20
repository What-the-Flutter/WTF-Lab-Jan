part of 'add_new_chat_cubit.dart';

@immutable
class AddNewChatState {
  final bool isTextFieldEmpty;
  final int selectedIconIndex;

  AddNewChatState({
    this.isTextFieldEmpty = true,
    required this.selectedIconIndex,
  });

  AddNewChatState copyWith({
    bool? isTextFieldEmpty,
    int? selectedIconIndex,
  }) {
    return AddNewChatState(
      isTextFieldEmpty: isTextFieldEmpty ?? this.isTextFieldEmpty,
      selectedIconIndex: selectedIconIndex ?? this.selectedIconIndex,
    );
  }
}
