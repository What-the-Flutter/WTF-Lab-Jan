import '../../event.dart';

class StatesTimelinePage {
  final List<Event> eventList;
  final bool isBubbleAlignment;
  final bool isCenterDateBubble;
  final bool isSearch;
  final bool isSortedByBookmarks;

  const StatesTimelinePage({
    this.eventList = const [],
    this.isBubbleAlignment = false,
    this.isCenterDateBubble = false,
    this.isSearch = false,
    this.isSortedByBookmarks = false,
  });

  StatesTimelinePage copyWith({
    final List<Event>? eventList,
    final bool? isBubbleAlignment,
    final bool? isCenterDateBubble,
    final bool? isSearch,
    final bool? isSortedByBookmarks,
  }) {
    return StatesTimelinePage(
      eventList: eventList ?? this.eventList,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      isSearch: isSearch ?? this.isSearch,
      isSortedByBookmarks: isSortedByBookmarks ?? this.isSortedByBookmarks,
    );
  }
}
