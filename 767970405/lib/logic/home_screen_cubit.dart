import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../repository/property_message.dart';
import '../repository/property_page.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenInitial> {
  final List<PropertyPage> eventPages = <PropertyPage>[
    PropertyPage(
      icon: Icons.book_sharp,
      title: 'Journal',
      messages: <PropertyMessage>[],
      creationTime: DateTime.now(),
      lastModifiedTime: DateTime.now(),
    ),
    PropertyPage(
      icon: Icons.import_contacts_rounded,
      title: 'Notes',
      messages: <PropertyMessage>[],
      creationTime: DateTime.now(),
      lastModifiedTime: DateTime.now(),
    ),
    PropertyPage(
      icon: Icons.nature_people,
      title: 'Gratitude',
      messages: <PropertyMessage>[],
      creationTime: DateTime.now(),
      lastModifiedTime: DateTime.now(),
    )
  ];

  HomeScreenCubit() : super(HomeScreenInitial(
    isPin: false,
    isEditMessages: false,
    isEditPage: false,
  ));

  void removePage(int iPage) {
    eventPages.removeAt(iPage);
    emit(state.copyWith(isEditPage: false, isEditMessages: false));
  }

  void pinPage(int index) {
    eventPages[index] = eventPages[index].copyWith(isPin: true);
    emit(state.copyWith(isPin: true,));
  }

  void editMessages(int index, List<PropertyMessage> list) {
    eventPages[index] = eventPages[index].copyWith(messages: list);
    emit(state.copyWith(isEditMessages: true));
  }

  void editPage(int index, PropertyPage page) {
    eventPages[index] = page;
    emit(state.copyWith(isEditPage: true));
  }

  void addPage(PropertyPage page) {
    eventPages.add(page);
    emit(state.copyWith());
  }
}
