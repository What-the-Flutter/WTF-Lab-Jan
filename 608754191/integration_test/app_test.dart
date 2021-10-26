import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:task_wtf/main.dart' as app;

void main() {
  group(
    'App Test',
    () {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      testWidgets(
        'fab app test',
        (tester) async {
          app.main();
          await tester.pumpAndSettle();
          final addPageButton = find.byType(FloatingActionButton).first;
          await tester.tap(addPageButton);
          await tester.pumpAndSettle();
          expect(addPageButton, findsOneWidget);
        },
      );
    },
  );
}
