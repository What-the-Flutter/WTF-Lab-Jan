import 'package:bloc_test/bloc_test.dart';
import 'package:chat_journal_cubit/data/models/event.dart';
import 'package:chat_journal_cubit/data/repository/event_repository.dart';
import 'package:chat_journal_cubit/pages/event_page/event_cubit.dart';
import 'package:chat_journal_cubit/pages/event_page/event_state.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockEventRepository extends Mock implements EventRepository {}

void main() {
  mainCubit();
}

void mainCubit() {
  late EventCubit eventCubit;
  late EventRepository eventRepository;
  final eventList = [
    Event(
      id: '',
      eventData: 'event_1',
      imagePath: '',
      creationDate: DateTime.now(),
      pageId: '',
      isSelected: false,
      isMarked: false,
      categoryName: '',
      categoryIcon: null,
    ),
    Event(
      id: '',
      eventData: 'event_2',
      imagePath: 'image_path_1',
      creationDate: DateTime.now(),
      pageId: '',
      isSelected: false,
      isMarked: false,
      categoryName: '',
      categoryIcon: null,
    ),
    Event(
      id: '',
      eventData: 'event_3',
      imagePath: '',
      creationDate: DateTime.now(),
      pageId: '',
      isSelected: false,
      isMarked: false,
      categoryName: '',
      categoryIcon: null,
    ),
  ];

  setUp(() {
    eventRepository = MockEventRepository();
    eventCubit = EventCubit(eventRepository);
  });

  group('EventCubit', () {
    blocTest<EventCubit, EventState>(
      'emits hash tag list when hashTagList() is called',
      build: () => EventCubit(eventRepository),
      act: (cubit) => cubit.hashTagList('some #text with #hash #tags'),
      expect: () => <Matcher>[
        isA<EventState>().having(
                (e) => e.hashTagList, 'hashTagList', ['#text', '#hash', '#tags'])
      ],
    );
    blocTest<EventCubit, EventState>(
      'emits search data when searchEvent() is called',
      build: () => EventCubit(eventRepository),
      seed: () => EventState(
        isEditing: false,
        isSelected: false,
        isMarked: false,
        isAllMarked: false,
        isSearching: false,
        isCategoryListOpened: false,
        isHashTagListOpened: false,
        searchData: '',
        selectedEventIndex: 1,
        selectedPage: -1,
        selectedImage: '',
        selectedCategoryIndex: -1,
        eventList: eventList,
        hashTagList: [],
        pageId: '',
      ),
      act: (cubit) => cubit.searchEvent('searched text'),
      expect: () => <Matcher>[
        isA<EventState>()
            .having((e) => e.searchData, 'searchData', 'searched text')
      ],
    );
    blocTest<EventCubit, EventState>(
      'emits edited state when edit() is called',
      build: () => EventCubit(eventRepository),
      seed: () => EventState(
        isEditing: false,
        isSelected: false,
        isMarked: false,
        isAllMarked: false,
        isSearching: false,
        isCategoryListOpened: false,
        isHashTagListOpened: false,
        searchData: '',
        selectedEventIndex: -1,
        selectedPage: -1,
        selectedImage: '',
        selectedCategoryIndex: -1,
        eventList: eventList,
        hashTagList: [],
        pageId: '',
      ),
      act: (cubit) => cubit.edit(2),
      expect: () => <Matcher>[
        isA<EventState>()
            .having((e) => e.isEditing, 'isEditing', true)
            .having((e) => e.selectedEventIndex, 'selectedEventIndex', 2)
            .having((e) => e.eventList[2].eventData, 'eventList[2].eventData',
            'event_3')
      ],
    );
  });
}
