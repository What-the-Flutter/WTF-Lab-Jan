import 'package:bloc/bloc.dart';

import '/data/repository/chat_repository.dart';
import '/data/repository/event_repository.dart';
import '/models/chat_model.dart';

part 'filter_screen_state.dart';

class FilterScreenCubit extends Cubit<FilterScreenState> {
  final ChatRepository chatRepository;
  final EventRepository eventRepository;

  FilterScreenCubit(
    this.eventRepository,
    this.chatRepository,
  ) : super(
          FilterScreenState(
            filterChatList: [],
            filterTagList: [],
            filterCategoryList: [],
          ),
        );

  void init() => emit(
        state.copyWith(
          searchText: '',
          filterChatList: [],
          filterTagList: [],
          filterCategoryList: [],
          isFilterOn: false,
          isTextfieldEmpty: true,
        ),
      );

  Future<void> fetchChatList() async {
    final chatList = await chatRepository.fetchChatList();
    emit(state.copyWith(chatList: chatList));
  }

  bool isChatSelected(Chat chat) {
    return state.filterChatList.contains(chat);
  }

  bool isCategorySelected(int index) {
    return state.filterCategoryList.contains(index);
  }

  void onCategorySelected(int categoryIndex) {
    final categoryList = state.filterCategoryList;
    isCategorySelected(categoryIndex)
        ? categoryList.remove(categoryIndex)
        : categoryList.add(categoryIndex);
    emit(state.copyWith(filterCategoryList: categoryList));
  }

  void onChatSelected(Chat chat) {
    final chatList = state.filterChatList;
    isChatSelected(chat) ? chatList.remove(chat) : chatList.add(chat);
    emit(state.copyWith(filterChatList: chatList));
  }

  void exitFilterScreen(String searchText) {
    emit(state.copyWith(isFilterOn: false));
    if (!state.isTextfieldEmpty) {
      emit(
        state.copyWith(
          searchText: searchText,
          isFilterOn: true,
        ),
      );
    }
    if (state.filterChatList.isNotEmpty ||
        state.filterTagList.isNotEmpty ||
        state.filterCategoryList.isNotEmpty) {
      emit(state.copyWith(isFilterOn: true));
    }
    print(state.isFilterOn);
  }

  void isTextFieldEmpty(String value) {
    if (value.isEmpty) {
      emit(state.copyWith(isTextfieldEmpty: true));
    } else {
      emit(state.copyWith(isTextfieldEmpty: false));
    }
  }

  void clearTextField() {
    emit(state.copyWith(isTextfieldEmpty: true));
  }
}
