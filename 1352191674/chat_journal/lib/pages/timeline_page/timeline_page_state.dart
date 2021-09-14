part of 'timeline_page_cubit.dart';

class TimelinePageState {
  final bool isIconButtonSearchPressed;
  final List<Event> allEventList;
  final bool isCenterDateBubble;
  final String searchText;
  final bool isSearchButtonPressed;
  final bool isWriting;
  final bool isEditing;
  final bool isAllBookmarked;

  TimelinePageState({
    required this.isIconButtonSearchPressed,
    required this.isCenterDateBubble,
    required this.searchText,
    required this.isSearchButtonPressed,
    required this.isWriting,
    required this.isEditing,
    required this.isAllBookmarked,
    required this.allEventList,
  });

  TimelinePageState copyWith({
    bool? isIconButtonSearchPressed,
    List<Event>? allEventList,
    bool? isCenterDateBubble,
    String? searchText,
    bool? isWriting,
    bool? isEditing,
    bool? isAllBookmarked,
    bool? isSearchButtonPressed,
  }) {
    return TimelinePageState(
      isIconButtonSearchPressed:
          isIconButtonSearchPressed ?? this.isIconButtonSearchPressed,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      searchText: searchText ?? this.searchText,
      isWriting: isWriting ?? this.isWriting,
      isEditing: isEditing ?? this.isEditing,
      isAllBookmarked: isAllBookmarked ?? this.isAllBookmarked,
      allEventList: allEventList ?? this.allEventList,
      isSearchButtonPressed:
          isSearchButtonPressed ?? this.isSearchButtonPressed,
    );
  }
}
