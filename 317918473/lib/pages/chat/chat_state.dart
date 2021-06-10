part of 'chat_cubit.dart';

enum ChatMethod {
  initial,
  work,
  selectByTag,
  close,
  addMessage,
  addImage,
  choosed,
  delete,
  clipboard,
  search,
  sharingProgress,
  sharingComplete,
  searchByTag,
  favorite,
  select,
  edit
}

abstract class ChatState extends Equatable {
  final List<Messages> message;
  final IconData tag;
  final ChatMethod method;
  const ChatState(this.message, this.method, [this.tag = Icons.home]);

  ChatState copyWith({
    final List<Messages> message,
    final ChatMethod method,
    final IconData tag,
  });

  @override
  List<Object> get props => [message,method, tag];
}

class ChatInitial extends ChatState {
  ChatInitial() : super([],ChatMethod.initial, Icons.home);

  @override
  ChatState copyWith({
    List<Messages>? message,
    ChatMethod? method,
    IconData? tag,
  }) {
    return ChatInitial();
  }
}

class ChatInWork extends ChatState {

  ChatInWork(List<Messages> message,ChatMethod method,
      IconData tag)
      : super(message,method, tag);

  @override
  ChatState copyWith({
    List<Messages>? message,
    ChatMethod? method,
    IconData? tag,
  }) {
    return ChatInWork(
      message ?? this.message,
      method ?? this.method,
      tag ?? this.tag,
    );
  }
}

class ChatOnChoose extends ChatState {
  final Messages currentMessage;

  ChatOnChoose(List<Messages> message,ChatMethod method,IconData tag, this.currentMessage,)
      : super(message,method,tag);

  @override
  ChatState copyWith({
    List<Messages>? message,
    ChatMethod? method,
    Messages? currentMessage,
    IconData? tag,
  }) {
    return ChatOnChoose(
      message ?? this.message,
      method ?? this.method,
      tag ?? this.tag,
      currentMessage ?? this.currentMessage,
      
    );
  }

  @override
  List<Object> get props => [message, currentMessage,method,tag];
}

class ChatNotifierOnSuccess extends ChatState {
  final String notifyMessage;

  ChatNotifierOnSuccess(
    this.notifyMessage,
    ChatMethod method,
    IconData tag,
  ) : super([],method, tag);

  @override
  ChatState copyWith({
    List<Messages>? message,
    ChatMethod? method,
    String? notifyMessage,
    IconData? tag,
  }) {
    return ChatNotifierOnSuccess(
      notifyMessage ?? this.notifyMessage,
      method ?? this.method,
      tag ?? this.tag,
    );
  }
}

class ChatSearchProgress extends ChatState {
  ChatSearchProgress(
    List<Messages> message,
    ChatMethod method,
    IconData tag,
  ) : super(message,method, tag);

  @override
  ChatState copyWith({
    List<Messages>? message,
    ChatMethod? method,
    IconData? tag,
  }) {
    return ChatSearchProgress(
      message ?? this.message,
      method ?? this.method,
      tag ?? this.tag,
    );
  }
}

class ChatChooseTagProcess extends ChatState {
  ChatChooseTagProcess(
    List<Messages> message,
    ChatMethod method,
    IconData tag,
  ) : super(message,method, tag);

  @override
  ChatState copyWith({
    List<Messages>? message,
    ChatMethod? method,
    IconData? tag,
  }) {
    return ChatChooseTagProcess(message ?? this.message,method ?? this.method, tag ?? this.tag,);
  }
}
