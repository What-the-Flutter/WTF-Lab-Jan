part of 'chat_screen_cubit.dart';

class ChatScreenState {
  final List<Event> eventList;
  final List<Chat> chatList;
  final Event? editingEvent;
  final bool isEditing;
  final bool isTextFieldEmpty;
  final bool isShowFavorites;
  final bool isSearching;
  final bool isCategoriesOpened;
  final int selectedItemsCount;
  final String categoryName;
  final IconData categoryIcon;

  ChatScreenState({
    this.chatList = const [],
    this.eventList = const [],
    this.isEditing = false,
    this.isTextFieldEmpty = true,
    this.isShowFavorites = false,
    this.isSearching = false,
    this.isCategoriesOpened = false,
    this.selectedItemsCount = 0,
    this.categoryName = 'Cansel',
    this.categoryIcon = Icons.close,
    this.editingEvent,
  });

  ChatScreenState copyWith({
    List<Chat>? chatList,
    List<Event>? eventList,
    Event? editingEvent,
    bool? isEditing,
    bool? isTextFieldEmpty,
    bool? isShowFavorites,
    bool? isSearching,
    bool? isCategoriesOpened,
    int? selectedItemsCount,
    String? categoryName,
    IconData? categoryIcon,
  }) {
    return ChatScreenState(
      eventList: eventList ?? this.eventList,
      chatList: chatList ?? this.chatList,
      editingEvent: editingEvent ?? this.editingEvent,
      isEditing: isEditing ?? this.isEditing,
      isTextFieldEmpty: isTextFieldEmpty ?? this.isTextFieldEmpty,
      isShowFavorites: isShowFavorites ?? this.isShowFavorites,
      selectedItemsCount: selectedItemsCount ?? this.selectedItemsCount,
      isCategoriesOpened: isCategoriesOpened ?? this.isCategoriesOpened,
      isSearching: isSearching ?? this.isSearching,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
    );
  }
}
