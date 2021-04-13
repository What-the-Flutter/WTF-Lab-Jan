import '../../event_page/event.dart';

class TimelinePageStates {
  final bool isIconButtonSearchPressed;
  final bool isAllBookmarked;
  final bool isWriting;
  final bool isCenterDateBubble;
  final String searchText;
  final List<Event> eventList;
  final bool isEditing;

  TimelinePageStates copyWith({
    final bool isWriting,
    final bool isIconButtonSearchPressed,
    final List<Event> eventList,
    final String searchText,
    final bool isAllBookmarked,
    final bool isCenterDateBubble,
    final bool isEditing,
    final String isSearchText,
  }) {
    return TimelinePageStates(
      isIconButtonSearchPressed:
          isIconButtonSearchPressed ?? this.isIconButtonSearchPressed,
      isWriting: isWriting ?? this.isWriting,
      isEditing: isEditing ?? this.isEditing,
      searchText: searchText ?? this.searchText,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      isAllBookmarked: isAllBookmarked ?? this.isAllBookmarked,
      eventList: eventList ?? this.eventList,
    );
  }

  const TimelinePageStates({
    this.isIconButtonSearchPressed,
    this.isAllBookmarked,
    this.isWriting,
    this.isCenterDateBubble,
    this.searchText,
    this.eventList,
    this.isEditing,
  });
}
