part of 'event_page_cubit.dart';

class EventsState {
  final bool eventSelected;
  final Event? selectedElement;
  final bool? isEditing;
  final bool isIconButtonSearchPressed;
  final bool isWriting;
  final bool? isWritingBottomTextField;
  final int? selectedTile;
  final Note? note;
  final List<Event>? eventList;
  final int? indexOfCircleAvatar;
  final bool? isEditingPhoto;
  final String? dateTime;
  final String? hourTime;
  final bool? isCenterDateBubble;
  final bool? isBubbleAlignment;
  final bool? isDateTimeModification;
  final bool? isAllBookmarked;
  final Event? event;

  EventsState copyWith({
    bool? eventSelected,
    Event? selectedElement,
    bool? isEditing,
    bool? isIconButtonSearchPressed,
    bool? isWriting,
    int? selectedTile,
    Note? note,
    List<Event>? eventList,
    bool? isWritingBottomTextField,
    int? indexOfCircleAvatar,
    bool? isEditingPhoto,
    String? dateTime,
    bool? isCenterDateBubble,
    bool? isBubbleAlignment,
    bool? isDateTimeModification,
    String? backgroundImagePath,
    String? hourTime,
    String? date,
    Event? event,
    bool? isAllBookmarked,
  }) {
    return EventsState(
      note: note ?? this.note,
      eventSelected: eventSelected ?? this.eventSelected,
      selectedElement: selectedElement ?? this.selectedElement,
      isEditing: isEditing ?? this.isEditing,
      isIconButtonSearchPressed:
      isIconButtonSearchPressed ?? this.isIconButtonSearchPressed,
      isWriting: isWriting ?? this.isWriting,
      selectedTile: selectedTile ?? this.selectedTile,
      eventList: eventList ?? this.eventList,
      indexOfCircleAvatar: indexOfCircleAvatar,
      isWritingBottomTextField:
      isWritingBottomTextField ?? this.isWritingBottomTextField,
      isEditingPhoto: isEditingPhoto ?? this.isEditingPhoto,
      dateTime: dateTime ?? this.dateTime,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isDateTimeModification:
      isDateTimeModification ?? this.isDateTimeModification,
      hourTime: hourTime ?? this.hourTime,
      event: event ?? this.event,
      isAllBookmarked: isAllBookmarked ?? this.isAllBookmarked,
    );
  }

  const EventsState({
    this.eventSelected = false,
    this.selectedElement,
    this.isEditing,
    this.isIconButtonSearchPressed = false,
    this.isWriting = false,
    this.isWritingBottomTextField,
    this.selectedTile,
    this.note,
    this.eventList,
    this.indexOfCircleAvatar,
    this.isEditingPhoto,
    this.dateTime,
    this.hourTime,
    this.isCenterDateBubble,
    this.isBubbleAlignment,
    this.isDateTimeModification,
    this.isAllBookmarked,
    this.event,
  });
}
