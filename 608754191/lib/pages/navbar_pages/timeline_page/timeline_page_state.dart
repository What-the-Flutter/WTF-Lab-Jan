part of 'timeline_page_cubit.dart';

class TimelinePageState {
  final List<Message>? messageList;
  final bool? isSearch;
  final bool? isSortedByBookmarks;

  const TimelinePageState({
    this.messageList,
    this.isSearch,
    this.isSortedByBookmarks,
  });

  TimelinePageState copyWith({
    final List<Message>? messageList,
    final bool? isSearch,
    final bool? isSortedByBookmarks,
  }) {
    return TimelinePageState(
      messageList: messageList ?? this.messageList,
      isSearch: isSearch ?? this.isSearch,
      isSortedByBookmarks: isSortedByBookmarks ?? this.isSortedByBookmarks,
    );
  }
}
