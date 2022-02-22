part of 'filter_screen_cubit.dart';

class FilterScreenState {
  final List<Chat> chatList;
  final List<Chat> filterChatList;
  final List<Chat> filterTagList;
  final List<int> filterCategoryList;
  final String searchText;
  final bool isTextfieldEmpty;
  final bool isFilterOn;

  FilterScreenState({
    this.chatList = const [],
    required this.filterChatList,
    required this.filterTagList,
    required this.filterCategoryList,
    this.searchText = '',
    this.isTextfieldEmpty = true,
    this.isFilterOn = false,
  });

  FilterScreenState copyWith({
    List<Chat>? chatList,
    List<Chat>? filterChatList,
    List<Chat>? filterTagList,
    List<int>? filterCategoryList,
    String? searchText,
    bool? isTextfieldEmpty,
    bool? isFilterOn,
  }) {
    return FilterScreenState(
      chatList: chatList ?? this.chatList,
      filterChatList: filterChatList ?? this.filterChatList,
      filterTagList: filterTagList ?? this.filterTagList,
      filterCategoryList: filterCategoryList ?? this.filterCategoryList,
      searchText: searchText ?? this.searchText,
      isTextfieldEmpty: isTextfieldEmpty ?? this.isTextfieldEmpty,
      isFilterOn: isFilterOn ?? this.isFilterOn,
    );
  }
}
