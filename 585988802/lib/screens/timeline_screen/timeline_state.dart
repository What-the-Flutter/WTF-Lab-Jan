import '../../models/event_message.dart';
import '../../models/suggestion.dart';
import '../../models/tag.dart';

class TimelineScreenState {
  List<EventMessage> filteredEventMessageList;
  List<EventMessage> eventMessageList;
  EventMessage selectedEventMessage;
  bool isSearchIconButtonPressed;
  bool isFavoriteButPressed;
  bool isEditing;
  List<Tag> tagList;
  final List<Suggestion> suggestionList;

  TimelineScreenState(
    this.filteredEventMessageList,
    this.eventMessageList,
    this.selectedEventMessage,
    this.isSearchIconButtonPressed,
    this.isFavoriteButPressed,
    this.isEditing,
    this.tagList,
    this.suggestionList,
  );

  TimelineScreenState copyWith({
    final List<EventMessage> filteredEventMessageList,
    final List<EventMessage> eventMessageList,
    final EventMessage selectedEventMessage,
    final bool isSearchIconButtonPressed,
    final bool isFavoriteButPressed,
    final bool isEditing,
    final bool isCategorySelected,
    final List<Tag> tagList,
    final List<Suggestion> suggestionList,
  }) {
    return TimelineScreenState(
      filteredEventMessageList ?? this.filteredEventMessageList,
      eventMessageList ?? this.eventMessageList,
      selectedEventMessage ?? this.selectedEventMessage,
      isSearchIconButtonPressed ?? this.isSearchIconButtonPressed,
      isFavoriteButPressed ?? this.isFavoriteButPressed,
      isEditing ?? this.isEditing,
      tagList ?? this.tagList,
      suggestionList ?? this.suggestionList,
    );
  }
}
