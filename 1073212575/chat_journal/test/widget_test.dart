import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:chat_journal/pages/add_page/add_page_cubit.dart';
import 'package:chat_journal/pages/add_page/add_page_state.dart';
import 'package:chat_journal/pages/add_page/add_page_screen.dart';
import 'package:chat_journal/pages/home_page/home_page_screen.dart';
import 'package:chat_journal/pages/settings/settings_state.dart';
import 'package:chat_journal/pages/settings/settings_cubit.dart';

class MockAddPageCubit extends MockCubit<AddPageState> implements AddPageCubit {
}

class FakeAddPageState extends Fake implements AddPageState {}


void main() {
  setUpAll(() {
    registerFallbackValue(FakeAddPageState());
  });
  group('AddPage', () {
    late AddPageCubit cubit;

    setUp(() {
      cubit = MockAddPageCubit();
    });

    testWidgets('loads TextField successfully', (WidgetTester tester) async {
      when(() => cubit.state).thenReturn(
        AddPageState(
          selectedIconIndex: 0,
          eventPages: [],
          isColorChanged: false,
        ),
      );
      final page = BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          home: AddPage(needsEditing: false, selectedPageIndex: 1),
        ),
      );
      await tester.pumpWidget(page);

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('calls setIconIndex when icon is tapped',
        (WidgetTester tester) async {
      when(() => cubit.state).thenReturn(
        AddPageState(
          selectedIconIndex: 0,
          eventPages: [],
          isColorChanged: false,
        ),
      );
      final page = BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          home: AddPage(needsEditing: false, selectedPageIndex: 1),
        ),
      );
      await tester.pumpWidget(page);
      await tester.tap(find.byIcon(Icons.headset_rounded));
      verify(() => cubit.setIconIndex(7)).called(1);
    });

    testWidgets('enters text in TextField', (WidgetTester tester) async {
      when(() => cubit.state).thenReturn(
        AddPageState(
          selectedIconIndex: 0,
          eventPages: [],
          isColorChanged: false,
        ),
      );
      final page = BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          home: AddPage(needsEditing: false, selectedPageIndex: 1),
        ),
      );
      await tester.pumpWidget(page);
      await tester.enterText(find.byType(TextField), 'I want to sleep');
      expect(find.text('I want to sleep'), findsOneWidget);
    });
  });
}
