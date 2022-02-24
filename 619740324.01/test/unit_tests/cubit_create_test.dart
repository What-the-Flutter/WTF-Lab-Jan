import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:my_project/pages/create_page/cubit_create_page.dart';
import 'package:my_project/pages/create_page/states_create_page.dart';

void main() {
  late CubitCreatePage cubitCreatePage;

  setUp(() {
    cubitCreatePage = CubitCreatePage();
  });

  group('cubitCreate', () {
    blocTest<CubitCreatePage, StatesCreatePage>(
      'emit [StatesCreatePage(setEditing: true)] when cubit.setEditing(true) is called',
      build: () => CubitCreatePage(),
      act: (cubit) => cubit.setEditing(true),
      expect: () => <dynamic>[
        StatesCreatePage(
          isEditing: true,
        ),
      ],
    );

    blocTest<CubitCreatePage, StatesCreatePage>(
      'emit [StatesCreatePage(isWriting: true)] when cubit.setWriting(true) is called',
      build: () => CubitCreatePage(),
      act: (cubit) => cubit.setWriting(true),
      expect: () => <dynamic>[
        StatesCreatePage(
          isWriting: true,
        ),
      ],
    );

    blocTest<CubitCreatePage, StatesCreatePage>(
      'emit [StatesCreatePage(selectedIndex: 2)] when cubit.setSelectedIndex(2) is called',
      build: () => CubitCreatePage(),
      act: (cubit) => cubit.setSelectedIndex(2),
      expect: () => <dynamic>[
        StatesCreatePage(
          selectedIndex: 2,
        ),
      ],
    );
  });
}
