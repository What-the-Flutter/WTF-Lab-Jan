import '../../data/model/event.dart';

class TimelineState {
  final List<Event> timelineList;
  final List<String> pageNameList;
  final bool isMarked;
  final bool isAllMarked;
  final bool isSearching;
  final String searchData;
  final List<String> hashtagList;
  final bool isSelectedHashtag;
  final List<String> selectedHashtagList;

  TimelineState({
    required this.timelineList,
    required this.pageNameList,
    required this.isMarked,
    required this.isAllMarked,
    required this.isSearching,
    required this.searchData,
    required this.hashtagList,
    required this.isSelectedHashtag,
    required this.selectedHashtagList,
  });

  TimelineState copyWith({
    List<Event>? timelineList,
    List<String>? pageNameList,
    bool? isMarked,
    bool? isAllMarked,
    bool? isSearching,
    String? searchData,
    List<String>? hashtagList,
    bool? isSelectedHashtag,
    List<String>? selectedHashtagList,
  }) {
    return TimelineState(
      timelineList: timelineList ?? this.timelineList,
      pageNameList: pageNameList ?? this.pageNameList,
      isMarked: isMarked ?? this.isMarked,
      isAllMarked: isAllMarked ?? this.isAllMarked,
      isSearching: isSearching ?? this.isSearching,
      searchData: searchData ?? this.searchData,
      hashtagList: hashtagList ?? this.hashtagList,
      isSelectedHashtag: isSelectedHashtag ?? this.isSelectedHashtag,
      selectedHashtagList: selectedHashtagList ?? this.selectedHashtagList,
    );
  }
}
