import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:my_project/theme/cubit_theme.dart';
import 'package:my_project/theme/states_theme.dart';

void main() {
  late CubitTheme cubitTheme;

  setUp(() {
    cubitTheme = CubitTheme();
  });

  group('cubit.setTextTheme(...)', () {
    blocTest<CubitTheme, StatesTheme>(
      'emit [StatesTheme(textTheme: StatesTheme.smallTextTheme)] when cubit.setTextTheme(1) is called',
      build: () => CubitTheme(),
      act: (cubit) => cubit.setTextTheme(1),
      expect: () => <dynamic>[
        StatesTheme(
          textTheme: StatesTheme.smallTextTheme,
        ),
      ],
    );

    blocTest<CubitTheme, StatesTheme>(
      'emit [StatesTheme(textTheme: StatesTheme.defaultTextTheme)] when cubit.setTextTheme(2) is called',
      build: () => CubitTheme(),
      act: (cubit) => cubit.setTextTheme(2),
      expect: () => <dynamic>[
        StatesTheme(
          textTheme: StatesTheme.defaultTextTheme,
        ),
      ],
    );

    blocTest<CubitTheme, StatesTheme>(
      'emit [StatesTheme(textTheme: StatesTheme.largeTextTheme)] when cubit.setTextTheme(3) is called',
      build: () => CubitTheme(),
      act: (cubit) => cubit.setTextTheme(3),
      expect: () => <dynamic>[
        StatesTheme(
          textTheme: StatesTheme.largeTextTheme,
        ),
      ],
    );
  });
}
