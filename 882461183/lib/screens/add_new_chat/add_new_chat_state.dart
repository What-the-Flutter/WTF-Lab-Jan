part of 'add_new_chat_cubit.dart';

@immutable
class AddNewChatState {
  final bool isTextFieldEmpty;
  final int selectedIconIndex;
  final List<Chat> chatList;

  AddNewChatState({
    this.isTextFieldEmpty = true,
    this.chatList = const [],
    required this.selectedIconIndex,
  });

  AddNewChatState copyWith({
    bool? isTextFieldEmpty,
    int? selectedIconIndex,
    List<Chat>? chatList,
  }) {
    return AddNewChatState(
      isTextFieldEmpty: isTextFieldEmpty ?? this.isTextFieldEmpty,
      chatList: chatList ?? this.chatList,
      selectedIconIndex: selectedIconIndex ?? this.selectedIconIndex,
    );
  }
}
