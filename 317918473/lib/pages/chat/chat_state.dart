part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  final List<Messages> message;
  final IconData tag;
  const ChatState(this.message, [this.tag = Icons.home]);

  ChatState copyWith({
    final List<Messages> message,
    final IconData tag,
  });

  @override
  List<Object> get props => [message, tag];
}

class ChatInitial extends ChatState {
  ChatInitial(List<Messages> message) : super(message, Icons.home);

  @override
  ChatState copyWith({
    List<Messages>? message,
    IconData? tag,
  }) {
    return ChatInitial(message ?? this.message);
  }
}

class ChatInWork extends ChatState {
  final bool isFavorite;

  ChatInWork(List<Messages> message, IconData tag, [this.isFavorite = false])
      : super(message, tag);

  @override
  ChatState copyWith({
    List<Messages>? message,
    bool? isFavorite,
    IconData? tag,
  }) {
    return ChatInWork(
      message ?? this.message,
      tag ?? this.tag,
      isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object> get props => [message, isFavorite];
}

class ChatOnChoose extends ChatState {
  final int onChoose;
  final bool isSelecteble;

  ChatOnChoose(List<Messages> message, this.onChoose, IconData tag,
      [this.isSelecteble = false])
      : super(message, tag);

  @override
  ChatState copyWith({
    List<Messages>? message,
    int? onChoose,
    IconData? tag,
  }) {
    return ChatOnChoose(
      message ?? this.message,
      onChoose ?? this.onChoose,
      tag ?? this.tag,
    );
  }

  @override
  List<Object> get props => [message, onChoose, isSelecteble];
}

class ChatClipBoardSuccess extends ChatState {
  final String clipBoardMessage;

  ChatClipBoardSuccess(
    this.clipBoardMessage,
    IconData tag,
  ) : super([], tag);

  @override
  ChatState copyWith({
    List<Messages>? message,
    String? clipBoardMessage,
    IconData? tag,
  }) {
    return ChatClipBoardSuccess(
      clipBoardMessage ?? this.clipBoardMessage,
      tag ?? this.tag,
    );
  }
}

class ChatSearchProgress extends ChatState {
  ChatSearchProgress(
    List<Messages> message,
    IconData tag,
  ) : super(message, tag);

  @override
  ChatState copyWith({
    List<Messages>? message,
    IconData? tag,
  }) {
    return ChatSearchProgress(
      message ?? this.message,
      tag ?? this.tag,
    );
  }
}

class ChatSharingProgress extends ChatState {
  final List<int> indexOfCategoryToShare;

  ChatSharingProgress(
    List<Messages> message,
    this.indexOfCategoryToShare,
    IconData tag,
  ) : super(message, tag);

  @override
  ChatState copyWith({
    List<Messages>? message,
    List<int>? index,
    IconData? tag,
  }) {
    return ChatSharingProgress(
      message ?? this.message,
      index ?? indexOfCategoryToShare,
      tag ?? this.tag,
    );
  }

  @override
  List<Object> get props => [message, indexOfCategoryToShare];
}

class ChatSharingComplete extends ChatState {
  final String messageAboutSharing;
  ChatSharingComplete(
      List<Messages> message, this.messageAboutSharing, IconData tag)
      : super(message, tag);

  @override
  ChatState copyWith({
    List<Messages>? message,
    String? messageAboutSharing,
    IconData? tag,
  }) {
    return ChatSharingComplete(
      message ?? this.message,
      messageAboutSharing ?? this.messageAboutSharing,
      tag ?? this.tag,
    );
  }
}

class ChatChooseTagProcess extends ChatState {
  ChatChooseTagProcess(
    List<Messages> message,
    IconData tag,
  ) : super(message, tag);

  @override
  ChatState copyWith({
    List<Messages>? message,
    IconData? tag,
  }) {
    return ChatChooseTagProcess(message ?? this.message, tag ?? this.tag);
  }
}

class ChatOnEdit extends ChatState {
  final int onChoose;

  ChatOnEdit(List<Messages> message, this.onChoose, IconData tag,
      )
      : super(message, tag);

  @override
  ChatState copyWith({
    List<Messages>? message,
    int? onChoose,
    IconData? tag,
  }) {
    return ChatOnEdit(
      message ?? this.message,
      onChoose ?? this.onChoose,
      tag ?? this.tag,
    );
  }

  @override
  List<Object> get props => [message, onChoose];
}
