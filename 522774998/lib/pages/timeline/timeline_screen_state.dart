import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../properties/property_message.dart';
import '../../properties/property_page.dart';

abstract class TimelineScreenState extends Equatable {
  final List<PropertyPage> pages;
  final Widget appBar;
  final List<PropertyMessage> list;
  final int counter;

  const TimelineScreenState({
    this.pages,
    this.counter,
    this.appBar,
    this.list,
  });

  @override
  String toString() {
    return 'ScreenMessageState{appBar: $appBar, list: $list,'
        ' counter: $counter,\n';
  }

  TimelineScreenState copyWith({
    final List<PropertyPage> pages,
    final Widget appBar,
    final List<PropertyMessage> list,
    final int counter,
  });

  @override
  List<Object> get props => [
        pages,
        appBar,
        counter,
        list,
      ];
}

class TimelineScreenAwait extends TimelineScreenState {
  TimelineScreenAwait({
    List<PropertyPage> pages,
    Widget appBar,
    int counter,
    List<PropertyMessage> list,
  }) : super(
          pages: pages,
          appBar: appBar,
          list: list,
          counter: counter,
  );

  @override
  TimelineScreenState copyWith({
    List<PropertyPage> pages,
    Widget appBar,
    List<PropertyMessage> list,
    int counter,
  }) {
    throw UnimplementedError();
  }
}

class TimelineScreenSelection extends TimelineScreenState {
  TimelineScreenSelection({
    List<PropertyPage> pages,
    Widget appBar,
    List<PropertyMessage> list,
    int counter,
  }) : super(
          pages: pages,
          appBar: appBar,
          list: list,
          counter: counter,
  );

  @override
  TimelineScreenState copyWith({
    final List<PropertyPage> pages,
    final Widget appBar,
    final List<PropertyMessage> list,
    final int counter,
  }) {
    return TimelineScreenSelection(
      pages: pages ?? this.pages,
      appBar: appBar ?? this.appBar,
      list: list ?? this.list,
      counter: counter ?? this.counter,
    );
  }
}

class TimelineScreenMain extends TimelineScreenState {
  TimelineScreenMain({
    List<PropertyPage> pages,
    Widget appBar,
    List<PropertyMessage> list,
    int counter,
  }) : super(
          pages: pages,
          appBar: appBar,
          list: list,
          counter: counter,
  );

  @override
  TimelineScreenState copyWith({
    final List<PropertyPage> pages,
    final Widget appBar,
    final int counter,
    final List<PropertyMessage> list,
  }) {
    return TimelineScreenMain(
      pages: pages ?? this.pages,
      appBar: appBar ?? this.appBar,
      list: list ?? this.list,
      counter: counter ?? this.counter,
    );
  }
}
