import '../entity/category.dart';
import '../entity/message.dart';

class ChatPageState {
  final bool? messageSelected;
  final int? indexOfSelectedElement;
  final bool? isEditing;
  final Category? category;
  final bool? isSending;
  final List<Category>? categories;
  final List<Message> messageList;
  final Message? message;
  final bool? isWriting;
  final int? iconIndex;
  ChatPageState({
    this.messageSelected,
    this.indexOfSelectedElement,
    this.isEditing,
    this.category,
    this.isSending,
    this.categories,
    this.message,
    this.messageList = const [],
    this.iconIndex,
    this.isWriting,
  });

  ChatPageState copyWith({
    final bool? messageSelected,
    final int? indexOfSelectedElement,
    final bool? isEditing,
    final Category? category,
    final bool? isSending,
    final List<Category>? categories,
    final List<Message>? messageList,
    final Message? message,
    final int? iconIndex,
    final bool? isWriting,
  }) {
    return ChatPageState(
      messageSelected: messageSelected ?? this.messageSelected,
      indexOfSelectedElement: indexOfSelectedElement ?? this.indexOfSelectedElement,
      isEditing: isEditing ?? this.isEditing,
      category: category ?? this.category,
      isSending: isSending ?? this.isSending,
      categories: categories ?? this.categories,
      messageList: messageList ?? this.messageList,
      message: message ?? this.message,
      iconIndex: iconIndex,
      isWriting: isWriting ?? this.isWriting,
    );
  }
}
