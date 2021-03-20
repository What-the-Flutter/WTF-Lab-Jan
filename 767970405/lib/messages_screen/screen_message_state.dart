part of 'screen_message_cubit.dart';

enum Mode { await, input, selection, edit, search }

class ScreenMessageState extends Equatable {
  final ModelPage page;
  final Mode mode;
  final List<ModelMessage> list;
  final int counter;
  final bool isBookmark;
  final bool enabledController;
  final IconData iconData;
  final Function onAddMessage;

  const ScreenMessageState({
    this.page,
    this.counter,
    this.mode,
    this.list,
    this.isBookmark,
    this.enabledController,
    this.iconData,
    this.onAddMessage,
  });

  @override
  String toString() {
    return 'ScreenMessageState{appBar: $mode, list: $list,'
        ' counter: $counter, isBookmark: $isBookmark,'
        ' enabledController: $enabledController,'
        ' onAdd: $onAddMessage}\n';
  }

  ScreenMessageState copyWith({
    final ModelPage page,
    final Mode mode,
    final List<ModelMessage> list,
    final int counter,
    final bool isBookmark,
    final bool enabledController,
    final IconData iconData,
    final Function onAddMessage,
  }) {
    return ScreenMessageState(
      page: page ?? this.page,
      mode: mode ?? this.mode,
      list: list ?? this.list,
      counter: counter ?? this.counter,
      isBookmark: isBookmark ?? this.isBookmark,
      enabledController: enabledController ?? this.enabledController,
      iconData: iconData ?? this.iconData,
      onAddMessage: onAddMessage ?? this.onAddMessage,
    );
  }

  @override
  List<Object> get props => [
        mode,
        counter,
        list,
        isBookmark,
        enabledController,
        iconData,
        onAddMessage,
      ];
}
