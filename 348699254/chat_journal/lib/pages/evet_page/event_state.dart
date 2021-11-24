import '../../data/models/event.dart';

class EventState {
  final bool isEditing;
  final bool isSelected;
  final bool isMarked;
  final bool isAllMarked;
  final bool isCategoryListOpened;
  final bool isSearching;
  final String searchData;
  final int selectedEventIndex;
  final int selectedPage;
  final String selectedImage;
  final int selectedCategoryIndex;
  final List<Event> eventList;
  final int pageId;

  EventState({
    required this.isEditing,
    required this.isSelected,
    required this.isMarked,
    required this.isAllMarked,
    required this.isSearching,
    required this.isCategoryListOpened,
    required this.searchData,
    required this.selectedImage,
    required this.selectedCategoryIndex,
    required this.selectedEventIndex,
    required this.selectedPage,
    required this.eventList,
    required this.pageId,
  });

  EventState copyWith({
    bool? isEditing,
    bool? isSelected,
    bool? isMarked,
    bool? isAllMarked,
    bool? isSearching,
    bool? isCategoryListOpened,
    String? searchData,
    int? selectedEventIndex,
    int? selectedPage,
    int? selectedCategoryIndex,
    String? selectedImage,
    List<Event>? eventList,
    int? pageId,
  }) {
    return EventState(
      isEditing: isEditing ?? this.isEditing,
      isSelected: isSelected ?? this.isSelected,
      isMarked: isMarked ?? this.isMarked,
      isAllMarked: isAllMarked ?? this.isAllMarked,
      isSearching: isSearching ?? this.isSearching,
      isCategoryListOpened: isCategoryListOpened ?? this.isCategoryListOpened,
      searchData: searchData ?? this.searchData,
      selectedEventIndex: selectedEventIndex ?? this.selectedEventIndex,
      selectedPage: selectedPage ?? this.selectedPage,
      selectedImage: selectedImage ?? this.selectedImage,
      selectedCategoryIndex:
      selectedCategoryIndex ?? this.selectedCategoryIndex,
      eventList: eventList ?? this.eventList,
      pageId: pageId ?? this.pageId,
    );
  }
}