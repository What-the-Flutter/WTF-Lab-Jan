import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../models/event_message.dart';

import '../../models/suggestion.dart';

abstract class EventScreenEvent {
  const EventScreenEvent();
}

class EventMessageListInit extends EventScreenEvent {
  final Suggestion listViewSuggestion;

  const EventMessageListInit(this.listViewSuggestion);
}

class EventMessageAdded extends EventScreenEvent {
  final EventMessage eventMessage;

  const EventMessageAdded(this.eventMessage);
}

class EventMessageDeleted extends EventScreenEvent {
  const EventMessageDeleted();
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

class EventMessageToFavorite extends EventScreenEvent {
  const EventMessageToFavorite();
}

class EventMessageEdited extends EventScreenEvent {
  final String editedNameOfEventMessage;

  const EventMessageEdited(this.editedNameOfEventMessage);
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

class EventMessageToFavoriteWithButton extends EventScreenEvent {
  final EventMessage eventMessage;

  const EventMessageToFavoriteWithButton(this.eventMessage);
}

class DateSelected extends EventScreenEvent {
  final DateTime selectedDate;

  const DateSelected(this.selectedDate);
}

class TimeSelected extends EventScreenEvent {
  final TimeOfDay selectedTime;

  const TimeSelected(this.selectedTime);
}
