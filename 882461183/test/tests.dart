import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/models/chat_model.dart';
import '../lib/models/event_model.dart';
import '../lib/main.dart'; as app;

void main() {
  group(
    'unit test',
    () {
      test(
        'Correct type of date time fields in page model objects',
        () {
          final testChat = Chat(
            id: '0',
            creationDate: DateTime.now(),
            elementName: 'name',
            iconIndex: 0,
            elementSubname: 'subname',
            isPinned: false,
          );

          expect(testChat.id.runtimeType, String);
          expect(testChat.creationDate.runtimeType, DateTime);
          expect(testChat.elementName.runtimeType, String);
          expect(testChat.iconIndex.runtimeType, int);
          expect(testChat.elementSubname.runtimeType, String);
          expect(testChat.isPinned.runtimeType, bool);
        },
      );

      Widget testableWidget({required Widget child}) {
        return MaterialApp(
          home: child,
        );
      }

      group(
        'widget test',
        () {
          testWidgets(
            'button has a title',
            (WidgetTester tester) async {
              Widget testShareButton = TextButton(
                child: Text('Share'),
                onPressed: () {},
              );
              await tester.pumpWidget(testableWidget(child: testShareButton));
              expect(find.text('Share'), findsOneWidget);
            },
          );
        },
      );

      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      group(
        'integ test',
        () {
          testWidgets(
            'integration test',
            (WidgetTester tester) async {
              app.main();
              await tester.pumpAndSettle();
              expect(find.text('Home'), findsOneWidget);
            },
          );
        },
      );
    },
  );
}
