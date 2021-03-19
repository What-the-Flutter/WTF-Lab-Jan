part of '../../pages/messages/screen_messages_cubit.dart';

abstract class ScreenMessagesState extends Equatable {
  final PropertyPage page;
  final Widget appBar;
  final List<PropertyMessage> list;
  final int counter;
  final bool enabledController;
  final IconData iconData;
  final Function onAddMessage;
  final IconData category;

  const ScreenMessagesState({
    this.page,
    this.counter,
    this.appBar,
    this.list,
    this.enabledController,
    this.iconData,
    this.onAddMessage,
    this.category,
  });

  @override
  String toString() {
    return 'ScreenMessageState{appBar: $appBar, list: $list,'
        ' counter: $counter,'
        ' enabledController: $enabledController,'
        ' onAdd: $onAddMessage,'
        ' category: $category}\n';
  }

  ScreenMessagesState copyWith({
    final PropertyPage page,
    final Widget appBar,
    final List<PropertyMessage> list,
    final int counter,
    final bool enabledController,
    final IconData iconData,
    final Function onAddMessage,
    final IconData category,
  });

  @override
  List<Object> get props => [
        appBar,
        counter,
        list,
        enabledController,
        iconData,
        onAddMessage,
        category,
      ];
}

class ScreenMessageAwait extends ScreenMessagesState {
  ScreenMessageAwait({
    PropertyPage page,
    Widget appBar,
    int counter,
    List<PropertyMessage> list,
    IconData iconData,
    Function onAddMessage,
    IconData category,
  }) : super(
            page: page,
            appBar: appBar,
            list: list,
            counter: counter,
            enabledController: true,
            iconData: iconData,
            onAddMessage: onAddMessage,
            category: category);

  @override
  ScreenMessagesState copyWith({
    PropertyPage page,
    Widget appBar,
    List<PropertyMessage> list,
    int counter,
    bool enabledController,
    IconData iconData,
    Function onAddMessage,
    IconData category,
  }) {
    throw UnimplementedError();
  }
}

class ScreenMessageInput extends ScreenMessagesState {
  ScreenMessageInput({
    PropertyPage page,
    Widget appBar,
    int counter,
    List<PropertyMessage> list,
    IconData iconData,
    Function onAddMessage,
    IconData category,
  }) : super(
            page: page,
            appBar: appBar,
            list: list,
            counter: counter,
            enabledController: true,
            iconData: iconData,
            onAddMessage: onAddMessage,
            category: category);

  @override
  ScreenMessagesState copyWith({
    final PropertyPage page,
    final Widget appBar,
    final List<PropertyMessage> list,
    final int counter,
    final bool enabledController,
    final IconData iconData,
    final Function onAddMessage,
    final IconData category,
  }) {
    return ScreenMessageInput(
      page: page ?? this.page,
      appBar: appBar ?? this.appBar,
      list: list ?? this.list,
      counter: counter ?? this.counter,
      iconData: iconData ?? this.iconData,
      onAddMessage: onAddMessage ?? this.onAddMessage,
      category: category ?? this.category,
    );
  }
}

class ScreenMessageSelection extends ScreenMessagesState {
  ScreenMessageSelection({
    PropertyPage page,
    Widget appBar,
    List<PropertyMessage> list,
    int counter,
    IconData iconData,
    Function onAddMessage,
    IconData category,
  }) : super(
          page: page,
          appBar: appBar,
          list: list,
          counter: counter,
          enabledController: false,
          iconData: iconData,
          onAddMessage: onAddMessage,
          category: category,
        );

  @override
  ScreenMessagesState copyWith({
    final PropertyPage page,
    final Widget appBar,
    final List<PropertyMessage> list,
    final int counter,
    final bool enabledController,
    final IconData iconData,
    final Function onAddMessage,
    final IconData category,
  }) {
    return ScreenMessageSelection(
      page: page ?? this.page,
      appBar: appBar ?? this.appBar,
      list: list ?? this.list,
      counter: counter ?? this.counter,
      iconData: iconData ?? this.iconData,
      onAddMessage: onAddMessage,
      category: category,
    );
  }
}

class ScreenMessageEdit extends ScreenMessagesState {
  ScreenMessageEdit({
    PropertyPage page,
    Widget appBar,
    List<PropertyMessage> list,
    int counter,
    IconData iconData,
    Function onEditMessage,
    IconData category,
  }) : super(
          page: page,
          appBar: appBar,
          list: list,
          counter: counter,
          enabledController: true,
          iconData: iconData,
          onAddMessage: onEditMessage,
          category: category,
        );

  @override
  ScreenMessagesState copyWith({
    final PropertyPage page,
    final Widget appBar,
    final int counter,
    final List<PropertyMessage> list,
    final bool enabledController,
    final IconData iconData,
    final Function onAddMessage,
    final IconData category,
  }) {
    return ScreenMessageEdit(
      page: page ?? this.page,
      appBar: appBar ?? this.appBar,
      list: list ?? this.list,
      counter: counter ?? this.counter,
      iconData: iconData ?? this.iconData,
      onEditMessage: onAddMessage ?? this.onAddMessage,
      category: category ?? this.category,
    );
  }
}
