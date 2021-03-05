import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../repository/pages_repository.dart';
import '../repository/property_page.dart';

part 'event_page_state.dart';

class EventPageCubit extends Cubit<EventPageState> {
  final PagesRepository repository;

  EventPageCubit({
    @required this.repository,
    @required int index,
  }) : super(
    EventPageState(
      title: repository.eventPages[index].title,
      icon: repository.eventPages[index].icon,
      isPin: repository.eventPages[index].isPin,
      time: repository.eventPages[index].creationTime,
    ),
  );

  void refreshDate(int index) {
    emit(
      state.copyWith(
        title: repository.eventPages[index].title,
        icon: repository.eventPages[index].icon,
        isPin: repository.eventPages[index].isPin,
        time: repository.eventPages[index].creationTime,
      ),
    );
  }

  void pinPage(int index) {
    repository.eventPages[index] =
        repository.eventPages[index].copyWith(isPin: !state.isPin);
    emit(state.copyWith(isPin: !state.isPin));
  }

  void editPage(int index, PropertyPage page) {
    repository.eventPages[index] = page;
    emit(state.copyWith(icon: page.icon, title: page.title));
  }
}
