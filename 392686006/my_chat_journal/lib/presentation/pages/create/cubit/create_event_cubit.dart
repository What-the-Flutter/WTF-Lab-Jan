import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../data/data.dart';
import '../../../../domain/entities/event.dart';

part 'create_event_state.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit() : super(CreateEventState());

  IconData? _currentIcon;
  final editingController = TextEditingController();

  void init() {
    _loadIcons();
    editingController.addListener(_swichFlag);
  }

  void _swichFlag() {
    if (editingController.text.isEmpty) {
      emit(state.copyWith(isContinue: false));
    } else {
      emit(state.copyWith(isContinue: true));
    }
  }

  void _loadIcons() {
    emit(
      CreateEventState(
        icons: defaultIcons,
        currentIcon: defaultIcons.first,
      ),
    );
  }

  @override
  Future<void> close() {
    editingController.dispose();
    return super.close();
  }

  Event? createEvent() {
    Event updateEvent;
    final title = editingController.text;
    if (title.isEmpty) return null;
    if (state.editEvent != null) {
      updateEvent = Event.from(state.editEvent!);
      updateEvent
        ..title = title
        ..icon = Icon(state.currentIcon, color: Colors.white);
    } else {
      updateEvent = Event(
        title: title,
        icon: Icon(state.currentIcon, color: Colors.white),
        iconIndex: state.icons.indexOf(state.currentIcon!),
      );
    }
    return updateEvent;
  }

  /// This method created new event or make it possible to change the current event
  void createOrEditEvent(Event? event) {
    /// Create event
    if (event == null) {
      emit(state.copyWith(
        editEvent: event,
        currentIcon: state.icons.first,
      ));
    }

    /// Edit event
    else {
      final icons = List<IconData>.from(state.icons);
      final currentIndex = icons.indexOf(event.icon.icon!);
      if (currentIndex != 0) {
        _currentIcon = event.icon.icon!;
      }

      emit(state.copyWith(
        icons: icons,
        editEvent: event,
        currentIcon: _currentIcon,
      ));
    }
  }

  void currentIcon(IconData icon) {
    emit(state.copyWith(currentIcon: icon));
  }
}
