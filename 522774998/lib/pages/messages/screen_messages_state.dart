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
  final String dateOfSending;
  final DateTime timeOfSending;

  const ScreenMessagesState({
    this.page,
    this.counter,
    this.appBar,
    this.list,
    this.enabledController,
    this.iconData,
    this.onAddMessage,
    this.category,
    this.dateOfSending,
    this.timeOfSending,
  });

  @override
  String toString() {
    return 'ScreenMessageState{appBar: $appBar, list: $list,'
        ' counter: $counter,'
        ' enabledController: $enabledController,'
        ' onAdd: $onAddMessage,'
        ' category: $category,'
        ' dateOfSending: $dateOfSending,'
        ' timeOfSending $timeOfSending}\n';
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
    final String dateOfSending,
    final DateTime timeOfSending,
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
        dateOfSending,
        timeOfSending,
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
    String dateOfSending,
    DateTime timeOfSending,
  }) : super(
          page: page,
          appBar: appBar,
          list: list,
          counter: counter,
          enabledController: true,
          iconData: iconData,
          onAddMessage: onAddMessage,
          category: category,
          dateOfSending: dateOfSending,
          timeOfSending: timeOfSending,
        );

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
    String dateOfSending,
    DateTime timeOfSending,
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
    String dateOfSending,
    DateTime timeOfSending,
  }) : super(
          page: page,
          appBar: appBar,
          list: list,
          counter: counter,
          enabledController: true,
          iconData: iconData,
          onAddMessage: onAddMessage,
          category: category,
          dateOfSending: dateOfSending,
          timeOfSending: timeOfSending,
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
    final String dateOfSending,
    final DateTime timeOfSending,
  }) {
    return ScreenMessageInput(
      page: page ?? this.page,
      appBar: appBar ?? this.appBar,
      list: list ?? this.list,
      counter: counter ?? this.counter,
      iconData: iconData ?? this.iconData,
      onAddMessage: onAddMessage ?? this.onAddMessage,
      category: category ?? this.category,
      dateOfSending: dateOfSending ?? this.dateOfSending,
      timeOfSending: timeOfSending ?? this.timeOfSending,
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
    String dateOfSending,
    DateTime timeOfSending,
  }) : super(
          page: page,
          appBar: appBar,
          list: list,
          counter: counter,
          enabledController: false,
          iconData: iconData,
          onAddMessage: onAddMessage,
          category: category,
          dateOfSending: dateOfSending,
          timeOfSending: timeOfSending,
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
    final String dateOfSending,
    final DateTime timeOfSending,
  }) {
    return ScreenMessageSelection(
      page: page ?? this.page,
      appBar: appBar ?? this.appBar,
      list: list ?? this.list,
      counter: counter ?? this.counter,
      iconData: iconData ?? this.iconData,
      onAddMessage: onAddMessage,
      category: category ?? this.category,
      dateOfSending: dateOfSending ?? this.dateOfSending,
      timeOfSending: timeOfSending ?? this.timeOfSending,
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
    String dateOfSending,
    DateTime timeOfSending,
  }) : super(
          page: page,
          appBar: appBar,
          list: list,
          counter: counter,
          enabledController: true,
          iconData: iconData,
          onAddMessage: onEditMessage,
          category: category,
          dateOfSending: dateOfSending,
          timeOfSending: timeOfSending,
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
    final String dateOfSending,
    final DateTime timeOfSending,
  }) {
    return ScreenMessageEdit(
      page: page ?? this.page,
      appBar: appBar ?? this.appBar,
      list: list ?? this.list,
      counter: counter ?? this.counter,
      iconData: iconData ?? this.iconData,
      onEditMessage: onAddMessage ?? this.onAddMessage,
      category: category ?? this.category,
      dateOfSending: dateOfSending ?? this.dateOfSending,
      timeOfSending: timeOfSending ?? this.timeOfSending,
    );
  }
}
