import '../event.dart';

class StatesTimelinePage {
  final List<Event> eventsList;
  final bool isBubbleAlignment;
  final bool isCenterDateBubble;
  final bool isSearch;
  final bool isSortedByBookmarks;

  const StatesTimelinePage({
    this.eventsList,
    this.isBubbleAlignment,
    this.isCenterDateBubble,
    this.isSearch,
    this.isSortedByBookmarks,
  });

  StatesTimelinePage copyWith({
    final List<Event> eventsList,
    final bool isBubbleAlignment,
    final bool isCenterDateBubble,
    final bool isSearch,
    final bool isSortedByBookmarks,
  }) {
    return StatesTimelinePage(
      eventsList: eventsList ?? this.eventsList,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      isSearch: isSearch ?? this.isSearch,
      isSortedByBookmarks: isSortedByBookmarks ?? this.isSortedByBookmarks,
    );
  }
}
