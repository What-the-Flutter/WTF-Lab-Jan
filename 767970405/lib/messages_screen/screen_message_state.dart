part of 'screen_message_cubit.dart';

abstract class ScreenMessageState extends Equatable {
  final ModelPage page;
  final Widget appBar;
  final List<ModelMessage> list;
  final int counter;
  final bool isBookmark;
  final bool enabledController;
  final IconData iconData;
  final Function onAddMessage;

  const ScreenMessageState({
    this.page,
    this.counter,
    this.appBar,
    this.list,
    this.isBookmark,
    this.enabledController,
    this.iconData,
    this.onAddMessage,
  });

  @override
  String toString() {
    return 'ScreenMessageState{appBar: $appBar, list: $list,'
        ' counter: $counter, isBookmark: $isBookmark,'
        ' enabledController: $enabledController,'
        ' onAdd: $onAddMessage}\n';
  }

  ScreenMessageState copyWith({
    final ModelPage page,
    final Widget appBar,
    final List<ModelMessage> list,
    final int counter,
    final bool isBookmark,
    final bool enabledController,
    final IconData iconData,
    final Function onAddMessage,
  });

  @override
  List<Object> get props => [
        appBar,
        counter,
        list,
        isBookmark,
        enabledController,
        iconData,
        onAddMessage,
      ];
}

class ScreenMessageAwait extends ScreenMessageState {
  ScreenMessageAwait({
    ModelPage page,
    Widget appBar,
    int counter,
    List<ModelMessage> list,
    bool isBookmark,
    IconData iconData,
    Function onAddMessage,
  }) : super(
          page: page,
          appBar: appBar,
          list: list,
          counter: counter,
          isBookmark: isBookmark,
          enabledController: true,
          iconData: iconData,
          onAddMessage: onAddMessage,
        );

  @override
  ScreenMessageState copyWith({
    ModelPage page,
    Widget appBar,
    List<ModelMessage> list,
    int counter,
    bool isBookmark,
    bool enabledController,
    IconData iconData,
    Function onAddMessage,
  }) {
    throw UnimplementedError();
  }
}

class ScreenMessageInput extends ScreenMessageState {
  ScreenMessageInput({
    ModelPage page,
    Widget appBar,
    int counter,
    List<ModelMessage> list,
    bool isBookmark,
    IconData iconData,
    Function onAddMessage,
  }) : super(
          page: page,
          appBar: appBar,
          list: list,
          counter: counter,
          isBookmark: isBookmark,
          enabledController: true,
          iconData: iconData,
          onAddMessage: onAddMessage,
        );

  @override
  ScreenMessageState copyWith({
    final ModelPage page,
    final Widget appBar,
    final List<ModelMessage> list,
    final int counter,
    final bool isBookmark,
    final bool enabledController,
    final IconData iconData,
    final Function onAddMessage,
  }) {
    return ScreenMessageInput(
      page: page ?? this.page,
      appBar: appBar ?? this.appBar,
      list: list ?? this.list,
      counter: counter ?? this.counter,
      isBookmark: isBookmark ?? this.isBookmark,
      iconData: iconData ?? this.iconData,
      onAddMessage: onAddMessage ?? this.onAddMessage,
    );
  }
}

class ScreenMessageSelection extends ScreenMessageState {
  ScreenMessageSelection({
    ModelPage page,
    Widget appBar,
    List<ModelMessage> list,
    int counter,
    bool isBookmark,
    IconData iconData,
    Function onAddMessage,
  }) : super(
          page: page,
          appBar: appBar,
          list: list,
          counter: counter,
          isBookmark: isBookmark,
          enabledController: false,
          iconData: iconData,
          onAddMessage: onAddMessage,
        );

  @override
  ScreenMessageState copyWith({
    final ModelPage page,
    final Widget appBar,
    final List<ModelMessage> list,
    final int counter,
    final bool isBookmark,
    final bool enabledController,
    final IconData iconData,
    final Function onAddMessage,
  }) {
    return ScreenMessageSelection(
      page: page ?? this.page,
      appBar: appBar ?? this.appBar,
      list: list ?? this.list,
      counter: counter ?? this.counter,
      isBookmark: isBookmark ?? this.isBookmark,
      iconData: iconData ?? this.iconData,
      onAddMessage: onAddMessage,
    );
  }
}

class ScreenMessageEdit extends ScreenMessageState {
  ScreenMessageEdit({
    ModelPage page,
    Widget appBar,
    List<ModelMessage> list,
    int counter,
    bool isBookmark,
    IconData iconData,
    Function onEditMessage,
  }) : super(
          page: page,
          appBar: appBar,
          list: list,
          counter: counter,
          isBookmark: isBookmark,
          enabledController: true,
          iconData: iconData,
          onAddMessage: onEditMessage,
        );

  @override
  ScreenMessageState copyWith({
    final ModelPage page,
    final Widget appBar,
    final int counter,
    final List<ModelMessage> list,
    final bool isBookmark,
    final bool enabledController,
    final IconData iconData,
    final Function onAddMessage,
  }) {
    return ScreenMessageEdit(
      page: page ?? this.page,
      appBar: appBar ?? this.appBar,
      list: list ?? this.list,
      counter: counter ?? this.counter,
      isBookmark: isBookmark ?? this.isBookmark,
      iconData: iconData ?? this.iconData,
      onEditMessage: onAddMessage ?? this.onAddMessage,
    );
  }
}
