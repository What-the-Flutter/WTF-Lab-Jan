part of 'chat_page_cubit.dart';

class ChatPageState {
  final List<Event>? events;
  final Category? category;
  final bool eventSelected;
  final bool isEditing;
  final bool isSending;
  final int indexOfSelectedEvent;

  ChatPageState({
    this.events,
    this.category,
    required this.isSending,
    required this.isEditing,
    required this.eventSelected,
    required this.indexOfSelectedEvent,
  });

  ChatPageState copyWith({
    final bool? isSending,
    final List<Event>? events,
    final Category? category,
    final bool? eventSelected,
    final bool? isEditing,
    final int? indexOfSelectedEvent,
  }) {
    return ChatPageState(
      isSending: isSending ?? this.isSending,
      events: events ?? this.events,
      isEditing: isEditing ?? this.isEditing,
      category: category ?? this.category,
      eventSelected: eventSelected ?? this.eventSelected,
      indexOfSelectedEvent: indexOfSelectedEvent ?? this.indexOfSelectedEvent,
    );
  }
}
