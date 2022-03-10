// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../lib/models/page_model.dart';
import '../lib/models/note_model.dart';
import '../lib/pages/settings/settings.dart';
import '../lib/pages/statistic/statistics.dart';
import '../lib/main.dart' as app;

import 'package:my_lab_project/main.dart';

void main() async {
  group('unit testing', () {
    test('Correct type of date time fields in page model objects', () {
      final testPage = PageModel(
        id: 1,
        title: 'test',
        icon: 1,
        cretionDate: DateTime.now().toString(),
        numOfNotes: 0,
        notesList: [],
        lastModifedDate: DateTime.now().toString(),
      );
      expect(testPage.cretionDate.runtimeType, String);
    });
    test('2', () {
      final testNote = NoteModel(
        id: 1,
        heading: 'headingText',
        data: 'dataText',
        icon: 1,
        isSearched: false,
        isFavorite: false,
        isChecked: false,
        downloadURL: "noteURL",
        tags: "noteTags",
      );
      expect(testNote.runtimeType, NoteModel);
    });

    test('3', () {
      final testNote = NoteModel(
        id: 1,
        heading: 'headingText',
        data: 'dataText',
        icon: 1,
        isSearched: false,
        isFavorite: false,
        isChecked: false,
        downloadURL: "noteURL",
        tags: "noteTags",
      );
      final testNoteMap = testNote.toMap(1);
      expect(testNoteMap.length, 9);
    });

    test('4', () {
      final testPage = PageModel(
        id: 1,
        title: 'test',
        icon: 1,
        cretionDate: DateTime.now().toString(),
        numOfNotes: 0,
        notesList: [],
        lastModifedDate: DateTime.now().toString(),
      );
      final testPageMap = testPage.toMap();
      expect(testPageMap.length, 6);
    });

    test('5', () {
      final testPage = PageModel(
        id: 1,
        title: 'test',
        icon: 1,
        cretionDate: DateTime.now().toString(),
        numOfNotes: 0,
        notesList: [],
        lastModifedDate: DateTime.now().toString(),
      );
      final testPageMap = testPage.toMap();
      final testPageFromMap = PageModel.fromMap(testPageMap);
      expect(testPageFromMap.runtimeType, PageModel);
    });
  });

  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  group('widget testing', () {
    testWidgets('button has a title', (WidgetTester tester) async {
      Widget testShareButton = shareButton();
      await tester.pumpWidget(makeTestableWidget(child: testShareButton));
      expect(find.text('Share'), findsOneWidget);
    });

    testWidgets('2', (WidgetTester tester) async {
      Widget testStaticticTile = staticticTile(
        color: Colors.black,
        width: 100.0,
        staticticTileCount: 0,
        staticticTileText: 'testText',
      );
      await tester.pumpWidget(makeTestableWidget(child: testStaticticTile));

      expect(find.text('testText'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('3', (WidgetTester tester) async {
      Widget testStaticticTile = staticticTile(
        color: Colors.black,
        width: 100.0,
        staticticTileCount: 0,
        staticticTileText: 'testText',
      );
      await tester.pumpWidget(makeTestableWidget(child: testStaticticTile));

      expect(find.byType(Text), findsNWidgets(2));
    });
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
    });
  });
}
