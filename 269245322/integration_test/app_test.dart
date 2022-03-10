import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_lab_project/pages/home/home.dart';
import 'package:my_lab_project/style/theme_cubit.dart';

import '../lib/main.dart' as app;
import '../lib/my_app.dart';
import '../lib/pages/home/home.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Future<void> addDelay(int ms) async {
    await Future<void>.delayed(Duration(milliseconds: ms));
  }

  group('end-to-end test', () {
    testWidgets('creating a new page', (tester) async {
      app.main();
      await addDelay(10000);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await addDelay(15000);
      expect(find.text('test_page'), findsNothing);

      final fab = find.byTooltip('iButton');

      await tester.tap(fab);
      await addDelay(5000);
      final fab2 = (find.text('Bookmarks'));
      await addDelay(5000);
      expect(fab2, findsOneWidget);
    });
  });
}
