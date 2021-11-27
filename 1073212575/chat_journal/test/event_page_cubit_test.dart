import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import '../lib/pages/event_page/event_page_cubit.dart';
import '../lib/pages/event_page/event_page_state.dart';
import '../lib/repository/pages_repository.dart';
import '../lib/repository/messages_repository.dart';
import 'package:chat_journal/repository/labels_repository.dart';
import 'package:mocktail/mocktail.dart';
import '../lib/pages/Timeline/timeline_cubit.dart';
import '../lib/models/events_model.dart';


class MockMessagesRepository extends Mock
    implements MessagesRepository {}

class MockPagesRepository extends Mock implements PagesRepository {}

class MockLabelsRepository extends Mock implements LabelsRepository {}

void main() {
  group('EventPageCubit', () {
    late MessagesRepository messages;
    late PagesRepository pages;
    late LabelsRepository labels;
    late EventPageCubit cubit;
    final messageList = [
      EventMessage(
        id: '',
        pageId: '1',
        text: '#3 3',
        imagePath: '',
        date: DateTime.utc(2021, 11, 18),
        icon: Icons.airplanemode_active_rounded,
        isMarked: false,
        isChecked: false,
      ),
      EventMessage(
        id: '',
        pageId: '1',
        text: '4#44 #4',
        imagePath: '',
        date: DateTime.utc(2021, 11, 17),
        icon: Icons.airplanemode_active_rounded,
        isMarked: false,
        isChecked: false,
      ),
      EventMessage(
        id: '',
        pageId: '',
        text: '',
        imagePath: '',
        date: DateTime.utc(2021, 11, 16),
        icon: Icons.airplanemode_active_rounded,
        isMarked: false,
        isChecked: false,
      ),
      EventMessage(
        id: '',
        pageId: '',
        text: '',
        imagePath: '',
        date: DateTime.utc(2021, 11, 15),
        icon: Icons.airplanemode_active,
        isMarked: false,
        isChecked: false,
      ),
    ];

    setUp(() {
      messages = MockMessagesRepository();
      pages = MockPagesRepository();
      labels = MockLabelsRepository();
      cubit = EventPageCubit(messages, pages, labels);
    });

    blocTest<EventPageCubit, EventPageState>(
      'emits selectedMessageIndex',
      build: () => EventPageCubit(messages, pages, labels),
      seed: () => EventPageState(
        labels: [],
        hashTags: [],
        messages: [],
        onlyMarked: false,
        isSelected: false,
        isSearchGoing: false,
        isLabelPanelOpened: false,
        isHashTagPanelVisible: false,
        needsEditing: false,
        isDateTimeSelected: false,
        isColorChanged: false,
        selectedMessageIndex: -1,
        selectedLabelIcon: Icons.remove_rounded,
        eventPageId: '',
        selectedImagePath: '',
        searchText: '',
        selectedTime: TimeOfDay.now(),
        selectedDate: DateTime.now(),
      ),
      act: (cubit) => cubit.select(3),
      expect: () => <Matcher>[
        isA<EventPageState>()
            .having((e) => e.selectedMessageIndex, 'selectedMessageIndex', 3)
            .having((e) => e.isSelected, 'isSelected', true)
      ],
    );

    blocTest<EventPageCubit, EventPageState>(
      'finds HashTags',
      build: () => EventPageCubit(messages, pages, labels),
      seed: () => EventPageState(
        labels: [],
        hashTags: [],
        messages: messageList,
        onlyMarked: false,
        isSelected: false,
        isSearchGoing: false,
        isLabelPanelOpened: false,
        isHashTagPanelVisible: false,
        needsEditing: false,
        isDateTimeSelected: false,
        isColorChanged: false,
        selectedMessageIndex: -1,
        selectedLabelIcon: Icons.remove_rounded,
        eventPageId: '',
        selectedImagePath: '',
        searchText: '',
        selectedTime: TimeOfDay.now(),
        selectedDate: DateTime.now(),
      ),
      act: (cubit) => cubit.findHashTags(),
      expect: () => <Matcher>[
        isA<EventPageState>()
            .having((e) => e.hashTags, 'hashTags', ['#3','#4'])
      ],
    );

    blocTest<EventPageCubit, EventPageState>(
      'finds HashTag matches',
      build: () => EventPageCubit(messages, pages, labels),
      seed: () => EventPageState(
        labels: [],
        hashTags: ['#44','#3','#4'],
        messages: messageList,
        onlyMarked: false,
        isSelected: false,
        isSearchGoing: false,
        isLabelPanelOpened: false,
        isHashTagPanelVisible: false,
        needsEditing: false,
        isDateTimeSelected: false,
        isColorChanged: false,
        selectedMessageIndex: -1,
        selectedLabelIcon: Icons.remove_rounded,
        eventPageId: '',
        selectedImagePath: '',
        searchText: '',
        selectedTime: TimeOfDay.now(),
        selectedDate: DateTime.now(),
      ),
      act: (cubit) => cubit.findHashtagMatches('5'),
      expect: () => <Matcher>[
        isA<EventPageState>()
            .having((e) => e.hashTags, 'hashTags', ['#44','#3','#4'])
            .having((e) => e.isHashTagPanelVisible, 'isHashTagPanelVisible', false)
      ],
    );

    blocTest<EventPageCubit, EventPageState>(
      'emits nothing when newDate == null',
      build: () => EventPageCubit(messages, pages, labels),
      seed: () => EventPageState(
        labels: [],
        hashTags: [],
        messages: [],
        onlyMarked: false,
        isSelected: false,
        isSearchGoing: false,
        isLabelPanelOpened: false,
        isHashTagPanelVisible: false,
        needsEditing: false,
        isDateTimeSelected: false,
        isColorChanged: false,
        selectedMessageIndex: -1,
        selectedLabelIcon: Icons.remove_rounded,
        eventPageId: '',
        selectedImagePath: '',
        searchText: '',
        selectedTime: TimeOfDay.now(),
        selectedDate: DateTime.now(),
      ),
      act: (cubit) => cubit.setDate(null),
      expect: () => <EventPageState>[
      ],
    );

  test("test to check areDaysEqual method", () {
    bool expected = true;
    var actual = cubit.areDaysEqual(
      DateTime.utc(2020, 1, 1, 1),
      DateTime.utc(2020, 1, 1, 2),
    );
    expect(actual, expected);
  });


  });
}




