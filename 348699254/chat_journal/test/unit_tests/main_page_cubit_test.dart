import 'package:bloc_test/bloc_test.dart';
import 'package:chat_journal_cubit/data/repository/page_repository.dart';
import 'package:chat_journal_cubit/pages/main_page/main_pade_cubit.dart';
import 'package:chat_journal_cubit/pages/main_page/main_page_state.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockActivityPageRepository extends Mock
    implements ActivityPageRepository {}

void main() {
  mainCubit();
}

void mainCubit() {
  late MainPageCubit mainPageCubit;
  late ActivityPageRepository pageRepository;
  setUp(() {
    pageRepository = MockActivityPageRepository();
    mainPageCubit = MainPageCubit(pageRepository);
  });

  group('MainPageCubit', () {
    blocTest<MainPageCubit, MainPageState>(
      'emits selected state when select() is called',
      build: () => MainPageCubit(pageRepository),
      act: (cubit) => cubit.select(2),
      expect: () => <Matcher>[
        isA<MainPageState>()
            .having((e) => e.selectedPageIndex, 'selectedPageIndex', 2)
            .having((e) => e.isSelected, 'isSelected', true)
      ],
    );
  });
}