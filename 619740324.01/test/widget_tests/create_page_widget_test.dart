import 'package:bloc_test/bloc_test.dart';
import 'package:my_project/pages/create_page/cubit_create_page.dart';
import 'package:my_project/pages/create_page/create_page.dart';
import 'package:my_project/pages/create_page/states_create_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCubitCreatePage extends MockCubit<StatesCreatePage> implements CubitCreatePage{}

class FakeCreatePageState extends Fake implements StatesCreatePage {}

void main() {
  setUpAll((){
    registerFallbackValue(FakeCreatePageState());
  });
  
  group('CreatePage', (){
    late CubitCreatePage cubitCreatePage;
    
    setUp((){
      cubitCreatePage = MockCubitCreatePage();
    });

    testWidgets('Input TextField', (tester) async {
      when(() => cubitCreatePage.state).thenReturn(
        StatesCreatePage(),
      );
      final page = BlocProvider<CubitCreatePage>.value(
        value: cubitCreatePage,
        child: const MaterialApp(
          home: CreatePage(),
        ),
      );
      await tester.pumpWidget(page);
      await tester.enterText(find.byType(TextField), 'Some text to input');
      expect(find.text('Some text to input'), findsOneWidget);
    });

    testWidgets('Load Widgets', (tester) async {
      when(() => cubitCreatePage.state).thenReturn(
        StatesCreatePage(),
      );
      final page = BlocProvider<CubitCreatePage>.value(
        value: cubitCreatePage,
        child: const MaterialApp(
          home: CreatePage(),
        ),
      );
      await tester.pumpWidget(page);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(CircleAvatar), findsNWidgets(10));
    });

    testWidgets('Tap CircleAvatar', (tester) async {
      when(() => cubitCreatePage.state).thenReturn(
        StatesCreatePage(),
      );
      final page = BlocProvider<CubitCreatePage>.value(
        value: cubitCreatePage,
        child: const MaterialApp(
          home:CreatePage(),
        ),
      );
      await tester.pumpWidget(page);
      await tester.tap(find.byType(CircleAvatar).first);
      verify(() => cubitCreatePage.setSelectedIndex(any())).called(1);
    });
  });
}