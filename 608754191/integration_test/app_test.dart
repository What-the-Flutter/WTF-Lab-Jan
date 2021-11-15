import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:task_wtf/main.dart' as app;
import 'package:task_wtf/pages/add_page/add_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group(
    'App Test',
    () {
      testWidgets(
        'add category',
        (tester) async {
          app.main();
          await tester.pumpAndSettle();
          final addPageButton = find.byType(FloatingActionButton).first;
          await tester.tap(addPageButton);
          await tester.pumpAndSettle();
          final addPage = find.byType(AddPage);
          expect(addPage, findsOneWidget);
          await tester.enterText(find.byType(TextField), 'ABC');
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.done));
          await tester.pumpAndSettle();
          expect(find.text('ABC'), findsOneWidget);
        },
      );
      testWidgets(
        'text test',
        (tester) async {
          app.main();
          await tester.pumpAndSettle();
          await tester.tap(find.text('Timeline'));
          await tester.pumpAndSettle();
          expect(find.byIcon(Icons.bookmark_border_outlined), findsOneWidget);
        },
      );
    },
  );
}
