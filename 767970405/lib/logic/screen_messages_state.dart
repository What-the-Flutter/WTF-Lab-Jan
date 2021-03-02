part of 'screen_messages_cubit.dart';

@immutable
abstract class ScreenMessagesState {
  final bool isBookmarkMsg;
  final int countDeletedMsg;

  ScreenMessagesState({
    this.isBookmarkMsg,
    this.countDeletedMsg,
  });
}

class ScreenMessagesInput extends ScreenMessagesState {
  ScreenMessagesInput({bool isBookmark = false})
      : super(
          isBookmarkMsg: isBookmark,
          countDeletedMsg: 0,
        );
}

class ScreenMessagesSelected extends ScreenMessagesState {
  ScreenMessagesSelected({
    bool isBookmark = false,
    int countDeletedMsg,
  }) : super(
          isBookmarkMsg: isBookmark,
          countDeletedMsg: countDeletedMsg,
        );
}

class ScreenMessagesEdit extends ScreenMessagesState {
  ScreenMessagesEdit({bool isBookmark = false})
      : super(
          isBookmarkMsg: isBookmark,
          countDeletedMsg: 0,
        );
}
