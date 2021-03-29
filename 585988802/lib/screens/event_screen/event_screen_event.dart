import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../models/event_message.dart';
import '../../models/suggestion.dart';
import '../../models/tag.dart';

abstract class EventScreenEvent {
  const EventScreenEvent();
}

class EventMessageListInit extends EventScreenEvent {
  final Suggestion listViewSuggestion;

  const EventMessageListInit(this.listViewSuggestion);
}

class EventMessageAdded extends EventScreenEvent {
  final EventMessage eventMessage;
  final List<EventMessage> eventMessageList;

  const EventMessageAdded(this.eventMessage, this.eventMessageList);
}

class EventMessageForwardAdded extends EventScreenEvent {
  final EventMessage eventMessage;

  const EventMessageForwardAdded(this.eventMessage);
}

class EventMessageDeleted extends EventScreenEvent {
  final List<EventMessage> eventMessageList;

  const EventMessageDeleted(this.eventMessageList);
}

class EventMessageSelected extends EventScreenEvent {
  final EventMessage selectedEventMessage;

  const EventMessageSelected(this.selectedEventMessage);
}

class SelectedCategoryAdded extends EventScreenEvent {
  final Category selectedCategory;

  const SelectedCategoryAdded(this.selectedCategory);
}

class UpdateEventMessageList extends EventScreenEvent {
  final int idOfSuggestion;

  const UpdateEventMessageList(this.idOfSuggestion);
}

class EventMessageEdited extends EventScreenEvent {
  final String editedNameOfEventMessage;
  final List<EventMessage> eventMessageList;

  const EventMessageEdited(
      this.editedNameOfEventMessage, this.eventMessageList);
}

class EditingModeChanged extends EventScreenEvent {
  final bool isEditing;

  const EditingModeChanged(this.isEditing);
}

class SearchIconButtonUnpressed extends EventScreenEvent {
  final List<EventMessage> eventMessageList;
  final bool isSearchIconButtonPressed;

  const SearchIconButtonUnpressed(
      this.eventMessageList, this.isSearchIconButtonPressed);
}

class SearchIconButtonPressed extends EventScreenEvent {
  final bool isSearchIconButtonPressed;

  const SearchIconButtonPressed(this.isSearchIconButtonPressed);
}

class FavoriteButPressed extends EventScreenEvent {
  final bool isFavoriteButPressed;

  const FavoriteButPressed(this.isFavoriteButPressed);
}

class EventMessageListFiltered extends EventScreenEvent {
  final List<EventMessage> eventMessageList;
  final String searchEventMessage;

  const EventMessageListFiltered(
      this.eventMessageList, this.searchEventMessage);
}

class EventMessageListFilteredReceived extends EventScreenEvent {
  const EventMessageListFilteredReceived();
}

class SendButtonChanged extends EventScreenEvent {
  final bool isWriting;

  const SendButtonChanged(this.isWriting);
}

class CategorySelectedModeChanged extends EventScreenEvent {
  final bool isCategorySelected;
  final Category selectedCategory;

  const CategorySelectedModeChanged(
      this.isCategorySelected, this.selectedCategory);
}

class EventMessageToFavorite extends EventScreenEvent {
  final EventMessage eventMessage;

  const EventMessageToFavorite(this.eventMessage);
}

class DateSelected extends EventScreenEvent {
  final DateTime selectedDate;

  const DateSelected(this.selectedDate);
}

class TimeSelected extends EventScreenEvent {
  final TimeOfDay selectedTime;

  const TimeSelected(this.selectedTime);
}

class CheckEventMessageForTagAndAdded extends EventScreenEvent {
  final String eventMessageText;
  final List<Tag> tagList;

  const CheckEventMessageForTagAndAdded(this.eventMessageText, this.tagList);
}

class TagDeleted extends EventScreenEvent {
  final Tag tag;
  final List<Tag> tagList;

  const TagDeleted(this.tag, this.tagList);
}

class UpdateTagList extends EventScreenEvent {
  const UpdateTagList();
}
