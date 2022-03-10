import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../lib/main.dart' as app;
import '../lib/my_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Future<void> addDelay(int ms) async {
    await Future<void>.delayed(Duration(milliseconds: ms));
  }

  group('end-to-end test', () {
    testWidgets('creating a new page', (tester) async {
      app.main();
    });
    testWidgets('creating a new page', (tester) async {
      await addDelay(10000);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await addDelay(5000);
      expect(find.text('test_page'), findsNothing);

      final fab = find.byTooltip('iButton');

      await tester.tap(fab);
      await addDelay(5000);
      final fab2 = (find.text('Bookmarks'));
      await addDelay(5000);
      expect(fab2, findsOneWidget);
    });
  });

  testWidgets('2', (tester) async {
    await addDelay(10000);
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    await addDelay(5000);

    final fab = find.byTooltip('iButton2');

    await tester.tap(fab);
    await addDelay(5000);
    final fab2 = (find.text('Settings'));
    await addDelay(5000);
    expect(fab2, findsOneWidget);
  });
}
