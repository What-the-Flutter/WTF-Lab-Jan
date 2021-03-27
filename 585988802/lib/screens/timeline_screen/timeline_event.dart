import '../../models/event_message.dart';
import '../../models/tag.dart';

abstract class TimelineScreenEvent {
  const TimelineScreenEvent();
}

class TimelineEventMessageListInit extends TimelineScreenEvent {
  const TimelineEventMessageListInit();
}

class TimelineEventMessageDeleted extends TimelineScreenEvent {
  final List<EventMessage> eventMessageList;

  const TimelineEventMessageDeleted(this.eventMessageList);
}

class TimelineEventMessageSelected extends TimelineScreenEvent {
  final EventMessage eventMessage;

  const TimelineEventMessageSelected(this.eventMessage);
}

class TimelineUpdateEventMessageList extends TimelineScreenEvent {
  const TimelineUpdateEventMessageList();
}

class TimelineEventMessageEdited extends TimelineScreenEvent {
  final String editedNameOfEventMessage;
  final List<EventMessage> eventMessageList;

  const TimelineEventMessageEdited(
      this.editedNameOfEventMessage, this.eventMessageList);
}

class TimelineEditingModeChanged extends TimelineScreenEvent {
  final bool isEditing;

  const TimelineEditingModeChanged(this.isEditing);
}

class TimelineSearchIconButtonUnpressed extends TimelineScreenEvent {
  final List<EventMessage> eventMessageList;
  final bool isSearchIconButtonPressed;

  const TimelineSearchIconButtonUnpressed(
      this.eventMessageList, this.isSearchIconButtonPressed);
}

class TimelineSearchIconButtonPressed extends TimelineScreenEvent {
  final bool isSearchIconButtonPressed;

  const TimelineSearchIconButtonPressed(this.isSearchIconButtonPressed);
}

class TimelineFavoriteButPressed extends TimelineScreenEvent {
  final bool isFavoriteButPressed;

  const TimelineFavoriteButPressed(this.isFavoriteButPressed);
}

class TimelineEventMessageListFiltered extends TimelineScreenEvent {
  final List<EventMessage> eventMessageList;
  final String searchEventMessage;

  const TimelineEventMessageListFiltered(
      this.eventMessageList, this.searchEventMessage);
}

class TimelineEventMessageListFilteredReceived extends TimelineScreenEvent {
  const TimelineEventMessageListFilteredReceived();
}

class TimelineEventMessageListFilteredBySuggestionName
    extends TimelineScreenEvent {
  final List<EventMessage> eventMessageList;
  final String nameOfSuggestion;

  const TimelineEventMessageListFilteredBySuggestionName(
      this.eventMessageList, this.nameOfSuggestion);
}

class TimelineEventMessageToFavorite extends TimelineScreenEvent {
  final EventMessage eventMessage;

  const TimelineEventMessageToFavorite(this.eventMessage);
}

class TimelineTagDeleted extends TimelineScreenEvent {
  final Tag tag;
  final List<Tag> tagList;

  const TimelineTagDeleted(this.tag, this.tagList);
}

class TimelineUpdateTagList extends TimelineScreenEvent {
  const TimelineUpdateTagList();
}
