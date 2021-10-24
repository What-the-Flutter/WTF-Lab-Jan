import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/message.dart';
import '../../../repositories/database.dart';
part 'timeline_page_state.dart';

class TimelinePageCubit extends Cubit<TimelinePageState> {
  TimelinePageCubit() : super(const TimelinePageState());

  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init() async {
    setMessageList(<Message>[]);
    setSearchState(false);
    setSortedByBookmarksState(false);
    setMessageList(await _databaseProvider.fetchFullMessageList());
  }

  void setSortedByBookmarksState(bool isSortedByBookmarks) {
    emit(
      state.copyWith(
        isSortedByBookmarks: isSortedByBookmarks,
      ),
    );
  }

  void setTextSearchState(bool isSearch) {
    emit(
      state.copyWith(
        isSearch: isSearch,
      ),
    );
  }

  void setSearchState(bool isSearch) {
    emit(
      state.copyWith(
        isSearch: isSearch,
      ),
    );
  }

  void setMessageList(List<Message> messageList) {
    emit(
      state.copyWith(
        messageList: messageList,
      ),
    );
  }
}
