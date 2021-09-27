import '../entity/category.dart';

class ChatPageState {
  final bool eventSelected;
  late final int indexOfSelectedElement;
  late final bool isEditing;
  final Category category;
  final bool isSending;

  ChatPageState(
      {required this.eventSelected,
      required this.indexOfSelectedElement,
      required this.isEditing,
      required this.category,
      required this.isSending});

  ChatPageState copyWith({
    final bool? eventSelected,
    final int? indexOfSelectedElement,
    final bool? isEditing,
    final Category? category,
    final bool? isSending,
  }) {
    return ChatPageState(
        eventSelected: eventSelected ?? this.eventSelected,
        indexOfSelectedElement: indexOfSelectedElement ?? this.indexOfSelectedElement,
        isEditing: isEditing ?? this.isEditing,
        category: category ?? this.category,
        isSending: isSending ?? this.isSending);
  }
}
