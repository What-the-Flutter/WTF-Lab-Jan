import 'package:bloc_test/bloc_test.dart';
import 'package:my_project/pages/event_page/cubit_event_page.dart';
import 'package:my_project/pages/event_page/event_page.dart';
import 'package:my_project/pages/event_page/states_event_page.dart';
import 'package:my_project/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventPage extends MockCubit<StatesEventPage>
    implements CubitEventPage {}

class FakeEventPageState extends Fake implements StatesEventPage {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeEventPageState());
  });

  group('EventPage', () {
    late CubitEventPage cubitEventPage;

    setUp(() {
      cubitEventPage = MockEventPage();
    });

    testWidgets('Load Widgets', (tester) async {
      when(() => cubitEventPage.state).thenReturn(
        StatesEventPage(),
      );
      final page = BlocProvider<CubitEventPage>.value(
        value: cubitEventPage,
        child: MaterialApp(
          home: EventPage(title: 'T', note: Note(), noteList: []),
        ),
      );
      await tester.pumpWidget(page);
      expect(find.text('T'), findsOneWidget);
    });
  });
}
