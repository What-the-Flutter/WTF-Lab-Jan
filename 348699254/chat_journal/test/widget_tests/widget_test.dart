import 'package:bloc_test/bloc_test.dart';
import 'package:chat_journal_cubit/pages/add_page/add_page_cubit.dart';
import 'package:chat_journal_cubit/pages/add_page/add_page_screen.dart';
import 'package:chat_journal_cubit/pages/add_page/add_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddPageCubit extends MockCubit<AddPageState> implements AddPageCubit {
}

class FakeAddPageState extends Fake implements AddPageState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAddPageState());
  });

  group('AddPageScreen', () {
    late AddPageCubit cubit;

    setUp(() {
      cubit = MockAddPageCubit();
    });

    testWidgets('Load Widgets', (tester) async {
      when(() => cubit.state).thenReturn(
        AddPageState(
          selectedIconIndex: 0,
          pageList: [],
        ),
      );
      final page = BlocProvider<AddPageCubit>.value(
        value: cubit,
        child: const MaterialApp(
          home: AddPageScreen(
            selectedPageIndex: 0,
            isEditing: true,
          ),
        ),
      );
      await tester.pumpWidget(page);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(GridTile), findsNWidgets(12));
      expect(find.byType(CircleAvatar), findsNWidgets(13));
    });

    testWidgets('Input TextField', (tester) async {
      when(() => cubit.state).thenReturn(
        AddPageState(
          selectedIconIndex: 0,
          pageList: [],
        ),
      );
      final page = BlocProvider<AddPageCubit>.value(
        value: cubit,
        child: const MaterialApp(
          home: AddPageScreen(
            selectedPageIndex: 0,
            isEditing: false,
          ),
        ),
      );
      await tester.pumpWidget(page);
      await tester.enterText(find.byType(TextField), 'Some text to input');
      expect(find.text('Some text to input'), findsOneWidget);
    });

    testWidgets('Tap CircleAvatar', (tester) async {
      when(() => cubit.state).thenReturn(
        AddPageState(
          selectedIconIndex: 0,
          pageList: [],
        ),
      );
      final page = BlocProvider<AddPageCubit>.value(
        value: cubit,
        child: const MaterialApp(
          home: AddPageScreen(
            selectedPageIndex: 0,
            isEditing: false,
          ),
        ),
      );
      await tester.pumpWidget(page);
      await tester.tap(find.byType(CircleAvatar).first);
      verify(() => cubit.setIconIndex(any())).called(1);
    });
  });
}